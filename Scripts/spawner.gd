extends Node

var utils = preload("res://Scripts/utils.gd")

var enemy_scene
var player_scene

var enemies_pool = []
var active_enemies = 0

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
#		print(result.distance_to(player_pos))
		result = get_random_in_circle(max_range)
	return result
	
func get_enemy_from_pool():
#	print(str(enemies_pool.size()) + " " + str(active_enemies))
	if enemies_pool.size() == active_enemies:
		return null
	return enemies_pool[active_enemies]
	
func spawn_player(root, pos):
	var player_inst = spawn(root, player_scene, pos)
#	print("Player spawned succsessfully at position " + str(pos))
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
#		print("spawner new enemy")
		enemy_inst = spawn(root, enemy_scene, pos)
		enemies_pool.append(enemy_inst)
		root.mutation_timer.connect("timeout", enemy_inst, "_mutate")
		root.connect("force_mutate", enemy_inst, "force_mutate")
		enemy_inst.set_player(player_inst)
		enemy_inst.set_spawner(self)
		swap_enemies_in_pool(enemies_pool.size() - 1, active_enemies)
	else:
		enemy_inst.translation = pos
	enemy_inst.activate()
	active_enemies += 1
#	print("Enemy spawned at " + str(pos))
	return enemy_inst
	
func spawn(root, _scene, pos):
	var inst = _scene.instance()
	root.add_child(inst)
	inst.global_translate(pos)
	return inst
	
func get_enemies_pool():
	return enemies_pool
	
func on_enemy_death(enemy_ind):
	active_enemies -= 1
	swap_enemies_in_pool(enemy_ind, active_enemies)

func swap_enemies_in_pool(a, b):
	enemies_pool[b].set_pool_index(a)
	enemies_pool[a].set_pool_index(b)
	if a == b:
		return
	var temp = enemies_pool[a]
	enemies_pool[a] = enemies_pool[b]
	enemies_pool[b] = temp
