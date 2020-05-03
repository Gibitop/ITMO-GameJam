extends Spatial

onready var enemy_scene = preload("res://Scenes/Enemy.tscn")

var start_angle: float
var start_point: Vector3
var angle: float = 0
var distance: float = 0

var active: bool = false

const NEAR_2PI = 2 * PI - 0.00001

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
		var next_point: Vector3 = _get_next_spiral_point(delta)
		transform = transform.translated(next_point - translation)

func _physics_process(delta):
	if active:
		check_collisions()

func _get_next_spiral_point(delta):
	distance += speed * delta * 100
	angle = distance * curvature + start_angle
	if angle > NEAR_2PI:
		angle = angle - NEAR_2PI
	var x = sin(angle) * distance
	var y = cos(angle) * distance
	return Vector3(x, 0, y) + start_point

func activate(_angle, _start_point):
	$AnimationPlayer.stop()
	$ProjectileBody.radius = 1
	translation = _start_point
	active = true
	visible = true
	start_angle = _angle # in rads
	start_point = _start_point
	yield(get_tree().create_timer(lifetime), "timeout")
	destroy()
	
func destroy():
#	$AnimationPlayer.play("Shrink")
#	yield($AnimationPlayer, "animation_finished")
	active = false
	visible = false
	yield(get_tree().create_timer(1), "timeout")
	free()
	
	
func check_collisions():
	for collision in $Area.get_overlapping_bodies():
#		print("!!!!!" + collision.get_class())
		if $Area.overlaps_body(collision) and \
		collision.get_class() == "RigidBody" and \
		collision.is_active() and \
		collision.visible:
			emit_signal("ememy_killed")
			collision.kill()
			destroy()
			break
