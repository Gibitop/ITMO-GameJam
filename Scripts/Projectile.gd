extends Spatial

onready var enemy_scene = preload("res://Scenes/Enemy.tscn")

var start_angle: float
var start_point: Vector3
var angle: float = 0
var distance: float = 0

var active: bool = false
var spawn_time

signal ememy_killed

export(float) var speed = 1
export(float) var curvature = 5
export(float) var lifetime = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active:
		check_collisions()
		if spawn_time > lifetime and not $AnimationPlayer.is_playing():
			destroy()
		else:
			spawn_time += delta
			var next_point: Vector3 = _get_next_spiral_point(delta)
			transform = transform.translated(next_point - translation)
	
func _get_next_spiral_point(delta):
	distance += speed * delta * 100
	angle = distance * curvature + start_angle
	if angle > 2 * PI:
		angle = angle - 2 * PI
	var x = sin(angle) * distance
	var y = cos(angle) * distance
	return Vector3(x, 0, y) + start_point

func activate(_angle, _start_point):
	$AnimationPlayer.stop()
	$ProjectileBody.radius = 1
	active = true
	spawn_time = 0
	start_angle = _angle # in rads
	start_point = _start_point
	
func destroy():
#	$AnimationPlayer.play("Shrink")
#	yield($AnimationPlayer, "animation_finished")
	active = false
	visible = false
#	free()
	
	
func check_collisions():
	for collision in $Area.get_overlapping_bodies():
		if collision.is_active():
			emit_signal("ememy_killed")
			collision.kill()
			destroy()
			break
