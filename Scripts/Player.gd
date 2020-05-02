extends Spatial

onready var utils = preload("res://Scripts/utils.gd")
onready var projectile_scene = preload("res://Scenes/Projectile.tscn")
onready var collider: Area = $Area

const MAX_HEALTH = 100;

var health = MAX_HEALTH;

const FIRE_BUTTON = KEY_SPACE


export (float) var max_push_disance = 10

export (float, EASE) var ease_curve = 0.0

export(int) var project_tile_count = 3
export (float) var default_kill_radius
export (float) var dashing_kill_radius
export(float) var DASHING_TIME = 333 # secs

var dashing = false
var dashing_start_time = 0.0
var dashing_target: Spatial
var energy: int = 3


func _ready():
	$Area/CollisionShape.shape.radius = default_kill_radius

# Восстанавливает amount очков здоровья
func heal(amount):
	health = min(health + amount, MAX_HEALTH)
	print("Player healed " + str(amount) + " hp")
	
# Наносит amount урона
func damage(amount):
	amount = max(amount, 0)
	#print("Player damaged by ", amount, " hp")
	health -= amount
	if health <= 0:
		pass
		#_die()

# TODO: обработка смерти
func _die():
	emit_signal("player_died")
	
func dash(target):
	print("Player dashing to " + str(target.translation))
	dashing_start_time = 0
	$Area/CollisionShape.shape.radius = dashing_kill_radius
	dashing = true
	dashing_target = target
	
func fire():
	if (energy > 0):
		energy -= 1
		print("FIRE")
		var rad_delta = (2 * PI) / project_tile_count
		print(rad_delta)
		for i in range(project_tile_count):
			var projectile_inst = projectile_scene.instance()
			print(str(i) + " " + str(i * rad_delta))
			get_parent().add_child(projectile_inst)
			projectile_inst.activate(i * rad_delta, translation)


func add_energy(amount=1):
	amount = max(amount, 0)
	#print("Added ", amount, " energy")
	energy += amount

func _input(event):
	if event is InputEventKey:
		if event.get_scancode_with_modifiers() == FIRE_BUTTON \
		and event.is_pressed() \
		and not event.is_echo():
			fire()
			
		if event.get_scancode_with_modifiers() == KEY_E \
		and event.is_pressed() \
		and not event.is_echo():
			_push_enemies(get_parent().get_all_enemies())

func _process(delta):
	var viewport  = get_parent().get_viewport()
	var cursor_world_position = utils.get_cursor_world_position(viewport, $Camera)
	$PlayerBody.look_at(cursor_world_position, Vector3(0, 1, 0))
	var pointer_z_scale = (translation - cursor_world_position).length() / 100
	print(pointer_z_scale)
	$PlayerBody/Pointer.scale = Vector3(0.5, 0.5, max(min(pointer_z_scale, 1), 0.2) )
	for collision in collider.get_overlapping_bodies():
		if collision.is_active():
			if collision.isMutated() or dashing:
				add_energy(1)
			else:
				damage(1)
	#			TODO: push around
			collision.kill()

	if dashing:
		dashing_start_time = dashing_start_time + delta
		var estimated_time = DASHING_TIME - dashing_start_time
		#print(str(estimated_time) + " " + str(dashing_start_time))
		if translation.distance_to(dashing_target.translation) < 1 or not dashing_target.is_active():
			dashing = false
			_push_enemies(get_parent().get_all_enemies())
			$Area/CollisionShape.shape.radius = default_kill_radius
#			print("Dashed to " + str(translation))

		else:
			var estimated_distance = translation.distance_to(dashing_target.translation)
			var speed = estimated_distance / estimated_time * delta * 1000 # units/millis
			var direction = (dashing_target.translation - translation).normalized()
			transform = transform.translated(direction * speed * ease(1 - estimated_time / DASHING_TIME, ease_curve))
		#transform.interpolate_with(dashing_target.transform, 1 - estimated_time / DASHING_TIME)

func _push_enemies(enemies):
	print("Pushing")
	for enemy in enemies:
		if not enemy.is_active():
			continue
		var push_direction = enemy.translation - translation
		var push_strength = max(0, max_push_disance - push_direction.length())
		var force = push_direction * push_strength 
		enemy.apply_central_impulse(force)
