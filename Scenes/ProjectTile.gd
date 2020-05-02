extends Spatial

var angle: float = 0
var distance: float = 0

export(float) var speed = 1
export(float) var curvature = 5

var t = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	t += delta
	if t > speed:
		t = 0
	var next_point: Vector3 = _get_next_spiral_point(delta)
	print(next_point)
	transform = transform.translated(next_point - translation)
	
func _get_next_spiral_point(delta):
	distance += speed * delta * 100
	angle = distance * curvature
	if angle > 2 * PI:
		angle = angle - 2 * PI
	var x = sin(angle) * distance
	var y = cos(angle) * distance
	return Vector3(x, 0, y)
