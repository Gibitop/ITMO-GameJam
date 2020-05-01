extends Spatial

onready var player_scene = preload("res://Scenes/Character.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_player(Vector3(0, 0, 0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Spawns player on pos
func spawn_player(pos:Vector3):
	var player_inst = player_scene.instance()
	add_child(player_inst)
	player_inst.global_translate(pos)
	print("Player spawned succsessfully at position " + str(pos))
	
func spawn_enemies():
	pass
