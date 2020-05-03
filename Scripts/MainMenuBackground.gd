extends Spatial

onready var spawner_script = load("res://Scripts/spawner.gd")

func _ready():
	pass

# Called when the node enters the scene tree for the first time.
func _process(delta):
	yield(get_tree().create_timer(1), "timout")
	
