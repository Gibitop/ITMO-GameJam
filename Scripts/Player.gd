extends Spatial

onready var utils = preload("res://Scripts/utils.gd")
onready var projectile_scene = preload("res://Scenes/Projectile.tscn")
onready var collider: Area = $Area

export (float)       var max_push_disance = 10
export (float, EASE) var ease_curve = 0.0 
export (float)       var default_kill_radius
export (float)       var dashing_kill_radius
export (float)       var DASHING_TIME = 333 # secs
export (float)       var max_health = 3

const FIRE_BUTTON = KEY_SPACE

signal player_died
signal combo_changed
signal money_changed
signal score_changed
signal energy_changed
signal health_changed
signal high_score_changed

var projectile_count = 3
var invincible: bool = false
var health = max_health;
var dashing = false
var dashing_start_time = 0.0
var dashing_target: Spatial
var energy: int = 5
var max_energy: int = 5
var push_power:float = 1.5

var projectile_lifetime = 2

var money = 0
var score = 0
var combo = 0
var combo_timer: Timer
var alive_timer: Timer
var user_data

func _ready():
	alive_timer = Timer.new()
	combo_timer = Timer.new()
	add_child(combo_timer)
	add_child(alive_timer)
	alive_timer.start()
	alive_timer.connect("timeout", self, "_increase_score")
	combo_timer.connect("timeout", self, "_reset_combo")
	_load_stats_from_user_data()
	$Area/CollisionShape.shape.radius = default_kill_radius

func _load_stats_from_user_data():
	user_data = get_node("/root/UserData")
	projectile_count = user_data.get_count_of_weapons()
	max_energy = user_data.get_max_energy()
	energy = max_energy
	push_power = user_data.get_push_power()

func _increase_score():
	score += 1
	emit_signal("score_changed", score)


# Восстанавливает amount очков здоровья
func heal(amount):
	health = min(health + amount, max_health)
	emit_signal("health_changed", health)
	print("Player healed " + str(amount) + " hp")
	
# Наносит amount урона
func damage(amount):
	if invincible:
		return
	amount = max(amount, 0)
	health -= amount
	emit_signal("health_changed", health)
	if health <= 0:
		pass
		_die()

# TODO: обработка смерти
func _die():
#	emit_signal("player_died")
#	Engine.time_scale = 0
	get_tree().paused = true
	get_parent().get_node("GameOver").visible = true
	_apply_label_text()
	user_data.set_money(user_data.get_money() + money)
	var high_score = user_data.get_high_score()
	if high_score < score:
		emit_signal("highscore_changed", score)
		user_data.set_high_score(score)
	user_data.save()

# Применяет актуальные данные к информации в меню (очки, деньги и тд)
func _apply_label_text():
	get_parent().get_node("GameOver/Container/Score").text = "Счёт: " + str(score) + " / " + str(user_data.get_high_score())
	get_parent().get_node("GameOver/Container/Money").text = "Деньги: " + str(user_data.get_money()) + " + " + str(money)

func dash(target):
	print("Player dashing to " + str(target.translation))
	dashing_start_time = 0
	$Area/CollisionShape.shape.radius = dashing_kill_radius
	dashing = true
	dashing_target = target

func _reset_combo():
	print('Combo reset (combo was: ', combo, ')')
	emit_signal("combo_changed", 0)
	combo_timer.stop()
	combo = 0

func fire():
	if (energy > 0):
		energy -= 1
		emit_signal("energy_changed", energy)
		print("FIRE")
		var rad_delta = (2 * PI) / projectile_count
		for i in range(projectile_count):
			var projectile_inst = projectile_scene.instance()
			projectile_inst.lifetime = projectile_lifetime
			projectile_inst.connect("ememy_killed", self, "_enemy_killed")
			get_parent().add_child(projectile_inst)
			projectile_inst.activate(i * rad_delta, translation)


func _enemy_killed():
	money += 1
	score += combo + 1
	emit_signal("money_changed", money)
	emit_signal("score_changed", score)

func add_energy(amount=1):
	amount = max(amount, 0)
	energy = min(energy + amount, max_energy)
	emit_signal("energy_changed", energy)


func _input(event):
	if event is InputEventKey:
		if event.get_scancode_with_modifiers() == FIRE_BUTTON \
		and event.is_pressed() \
		and not event.is_echo():
			fire()
			
		if event.get_scancode_with_modifiers() == KEY_E \
		and event.is_pressed() \
		and not event.is_echo() \
		and energy > 0:
			energy -= 1
			emit_signal("energy_changed", energy)
			_push_enemies(get_parent().get_all_enemies())

func _process(delta):
	var viewport  = get_parent().get_viewport()
	var cursor_world_position = utils.get_cursor_world_position(viewport, $Camera)
	$PlayerBody.look_at(cursor_world_position, Vector3(0, 1, 0))
	var pointer_z_scale = (translation - cursor_world_position).length() / 100
	$PlayerBody/Pointer.scale = Vector3(0.5, 0.5, max(min(pointer_z_scale, 1), 0.2) )

func _physics_process(delta):
	_process_collisions()
	_process_dash(delta)

func _push_enemies(enemies):
	invincible = true
	print("Pushing")
	for enemy in enemies:
		if not enemy.is_active():
			continue
		var push_direction = enemy.translation - translation
		var push_strength = max(0, max_push_disance - push_direction.length())
		var force = push_direction * push_strength * push_power
		enemy.apply_central_impulse(force)
	yield(get_tree().create_timer(0.5), "timeout")
	invincible = false

func _process_collisions():
	for collision in collider.get_overlapping_bodies():
		if collision.is_active():
			if collision.isMutated() or dashing:
				add_energy(1)
				score += combo + 1
				emit_signal("score_changed", score)
				money += 1
				emit_signal("money_changed", money)
			else:
				damage(1)
			if dashing:
				combo_timer.start()
				combo += 1
				emit_signal("combo_changed", combo)
			collision.kill()


func _process_dash(delta):
	if dashing:
		dashing_start_time = dashing_start_time + delta
		var estimated_time = DASHING_TIME - dashing_start_time
		if translation.distance_to(dashing_target.translation) < 1 or not dashing_target.is_active():
			dashing = false
			_push_enemies(get_parent().get_all_enemies())
			$Area/CollisionShape.shape.radius = default_kill_radius
		else:
			var estimated_distance = translation.distance_to(dashing_target.translation)
			var speed = estimated_distance / estimated_time * delta * 1000 # units/millis
			var direction = (dashing_target.translation - translation).normalized()
			transform = transform.translated(direction * speed * ease(1 - estimated_time / DASHING_TIME, ease_curve))

func shake_camera():
	$Came
