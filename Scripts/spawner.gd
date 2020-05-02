extends Node

var enemy_scene = load("res://Scripts/Player.gd")
var player_scene = load("res://Scripts/Enemy.gd")

func _init(_player_scene, _enemy_scene):
	enemy_scene = _enemy_scene
	player_scene = _player_scene
	
func get_enemy_position(min_range, max_range):
	randomize()
	var angle = rand_range(0, 2 * PI)
	var distance = rand_range(min_range, max_range)
	var x = cos(angle) * distance
	var y = sin(angle) * distance
	return Vector3(x, 0, y)

func spawn_enemy(root, pos, player_inst):
	var enemy_inst = spawn(root, enemy_scene, get_enemy_position(10, 30))
	enemy_inst.set_player(player_inst)
	enemy_inst.activate()
	root.mutation_timer.connect("timeout", enemy_inst, "_mutate")
	print("Enemy spawned at " + str(pos))
	return enemy_inst
	
func spawn_player(root, pos):
	var player_inst = spawn(root, player_scene, pos)
	print("Player spawned succsessfully at position " + str(pos))
	return player_inst
	
func spawn_enemies(root, count: int, player_inst):
	var res = []
	for i in range(count):
		var enemy_inst = spawn_enemy(root, get_enemy_position(10, 30), player_inst)
		res.append(enemy_inst)
	return res
	
func spawn(root, _scene, pos):
	var inst = _scene.instance()
	root.add_child(inst)
	inst.global_translate(pos)
	return inst
