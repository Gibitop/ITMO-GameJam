extends Spatial

const MAX_HEALTH = 100;

var health = MAX_HEALTH;

export(int) var DASHING_TIME = 333 # millis
var dashing = false
var dashing_start_time
var dashing_target: Spatial


func _ready():
	pass # Replace with function body.

# Восстанавливает amount очков здоровья
func heal(amount):
	health = min(health + amount, MAX_HEALTH)
	print("Player healed " + str(amount) + " hp")
	
# Наносит amount урона
func damage(amount):
	health -= amount
	if health <= 0:
		_die()

# TODO: обработка смерти
func _die():
	emit_signal("player_died")
	
func dash(target):
	print("Player dashing to " + str(target.translation))
	dashing_start_time = OS.get_ticks_msec()
	dashing = true
	dashing_target = target

func _process(delta):
	if dashing:
		var estimated_time = DASHING_TIME - (OS.get_ticks_msec() - dashing_start_time)
		if estimated_time <= 0:
			dashing = false
			print("Dashed to " + str(translation))
		else:
			var estimated_distance = translation.distance_to(dashing_target.translation)
			var speed = estimated_distance / estimated_time # units/millis
			var direction = (dashing_target.translation - translation).normalized()
			transform = transform.translated(direction * speed)
		
