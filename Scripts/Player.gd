extends Spatial

onready var projectile_scene = preload("res://Scenes/Projectile.tscn")
onready var collider: Area = $Area

const MAX_HEALTH = 100;

var health = MAX_HEALTH;

const FIRE_BUTTON = KEY_SPACE

export(int) var project_tile_count = 3

export(int) var DASHING_TIME = 333 # millis
var dashing = false
var dashing_start_time = 0.0
var dashing_target: Spatial
var energy: int = 3


func _ready():
	pass # Replace with function body.

# Восстанавливает amount очков здоровья
func heal(amount):
	health = min(health + amount, MAX_HEALTH)
	print("Player healed " + str(amount) + " hp")
	
# Наносит amount урона
func damage(amount):
	amount = max(amount, 0)
	print("Player damaged by ", amount, " hp")
	health -= amount
	if health <= 0:
		_die()

# TODO: обработка смерти
func _die():
	emit_signal("player_died")
	
func dash(target):
	print("Player dashing to " + str(target.translation))
	dashing_start_time = 0
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
	print("Added ", amount, " energy")
	energy += amount

func _input(event):
	if event is InputEventKey:
		if event.get_scancode_with_modifiers() == FIRE_BUTTON \
		and event.is_pressed() \
		and not event.is_echo():
			fire()

func _process(delta):
	for collision in collider.get_overlapping_bodies():
		var parent = collision.get_parent()
		if parent.is_active():
			if parent.isMutated():
				add_energy(1)
			else:
				damage(1)
	#			TODO: push around
			parent.kill()

	#var ray = $Camera.project_position(get_viewport().get_mouse_position(), 44)
	#print(ray)
	#translation = ray
	if dashing:
		dashing_start_time = dashing_start_time + delta
		var estimated_time = DASHING_TIME - dashing_start_time
		if estimated_time <= 0:
			dashing = false
#			print("Dashed to " + str(translation))
		else:
			var estimated_distance = translation.distance_to(dashing_target.translation)
			var speed = estimated_distance / estimated_time * delta * 1000 # units/millis
			var direction = (dashing_target.translation - translation).normalized()
			transform = transform.translated(direction * speed)
		
