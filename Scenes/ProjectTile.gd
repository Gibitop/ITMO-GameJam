extends Spatial

var start_angle: float
var start_point: Vector3
var angle: float = 0
var distance: float = 0

var active: bool = false

export(float) var speed = 1
export(float) var curvature = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active:
		var next_point: Vector3 = _get_next_spiral_point(delta)
		transform = transform.translated(next_point - translation)
	
func _get_next_spiral_point(delta):
	distance += speed * delta * 100
	angle = distance * curvature + start_angle
	if angle > 2 * PI:
		angle = angle - 2 * PI
	print(name + " " + str(angle))
	var x = sin(angle) * distance
	var y = cos(angle) * distance
	return Vector3(x, 0, y) + start_point

func activate(_angle, _start_point):
	active = true
	start_angle = _angle # in rads
	start_point = _start_point
	
func destroy():
	active = false
	visible = false

