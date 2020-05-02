extends Node

var enemy_scene
var player_scene

var enemies_pool = []

func _init(_player_scene, _enemy_scene):
	enemy_scene = _enemy_scene
	player_scene = _player_scene
	
func get_random_in_circle(radius):
	randomize()
	var angle = rand_range(0, 2 * PI)
	var distance = rand_range(0, radius)
	var x = cos(angle) * distance
	var y = sin(angle) * distance
	return Vector3(x, 0, y)
	
func get_enemy_position(min_range, max_range, player_pos):
	var result = get_random_in_circle(max_range) 
	while result.distance_to(player_pos) < min_range:
		print(result.distance_to(player_pos))
		result = get_random_in_circle(max_range)
	return result
	
func get_enemy_from_pool():
	for enemy in enemies_pool:
		if not enemy.is_active():
			print("enemy got from pool")
			return enemy
	return null
	
func spawn_player(root, pos):
	var player_inst = spawn(root, player_scene, pos)
	print("Player spawned succsessfully at position " + str(pos))
	return player_inst
	
func spawn_enemies(root, count: int, player_inst):
	var res = []
	for i in range(count):
		var enemy_inst = spawn_enemy(root, get_enemy_position(15, 50, player_inst.translation), player_inst)
		res.append(enemy_inst)
	return res
	
func spawn_enemy(root, pos, player_inst):
	var enemy_inst = get_enemy_from_pool()
	if enemy_inst == null:
		print("spawner new enemy")
		enemy_inst = spawn(root, enemy_scene, pos)
		enemies_pool.append(enemy_inst)
		root.mutation_timer.connect("timeout", enemy_inst, "_mutate")
		enemy_inst.set_player(player_inst)
	else:
		enemy_inst.translation = pos
	enemy_inst.activate()
	print("Enemy spawned at " + str(pos))
	return enemy_inst
	
func spawn(root, _scene, pos):
	var inst = _scene.instance()
	root.add_child(inst)
	inst.global_translate(pos)
	return inst
	
func get_enemies_pool():
	return enemies_pool
