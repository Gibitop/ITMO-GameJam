extends Spatial

onready var player_scene = preload("res://Scenes/Character.tscn")
onready var enemy_scene = preload("res://Scenes/Enemy.tscn")
onready var enemy = preload("res://Scripts/Enemy.gd")

var player
var enemies

# Called when the node enters the scene tree for the first time.
func _ready():
	player = spawn_player(Vector3(0, 0, 0))
	enemies = spawn_enemies(5, player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Spawns player on pos
func spawn_player(pos:Vector3):
	var player_inst = player_scene.instance()
	add_child(player_inst)
	player_inst.global_translate(pos)
	print("Player spawned succsessfully at position " + str(pos))
	return player_inst

func spawn_enemies(count, player_inst):
	var result = []
	for i in range(count):
		var pos: Vector3 = _get_enemy_position(30.0)
		var enemy_inst = enemy_scene.instance()
		result.append(enemy_inst)
		add_child(enemy_inst)
		enemy_inst.global_translate(pos)
		enemy_inst.set_player(player_inst)
		enemy_inst.activate()
		print("Enemy spawned at " + str(pos))
	return result

func _get_enemy_position(max_range):
	randomize()
	var angle = rand_range(0, 2 * PI)
	var distance = rand_range(10, max_range)
	var x = cos(angle) * distance
	var y = sin(angle) * distance
	return Vector3(x, 0, y)
