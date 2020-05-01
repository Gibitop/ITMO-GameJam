extends Spatial

var mutated: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func mutate():
	mutated = true
	
func isMutated():
	return mutated

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
