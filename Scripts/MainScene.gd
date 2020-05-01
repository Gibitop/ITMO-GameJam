extends Spatial

onready var player_scene = preload("res://Scenes/Player.tscn")
onready var enemy_scene = preload("res://Scenes/Enemy.tscn")
onready var enemy = preload("res://Scripts/Enemy.gd")

var player: Spatial
var enemies

# Called when the node enters the scene tree for the first time.
func _ready():
	player = spawn_player(Vector3(0, 0, 0))
	enemies = spawn_enemies(5, player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	var nearest_enemy = _find_nearest_enemy_to_cursor(_get_cursor_world_position())
	#if nearest_enemy.isMutated():
	(player.get_node("PlayerBody") as Spatial).look_at_from_position(Vector3(0, 0, 0), nearest_enemy.translation, Vector3(0, 1, 0))
	print(nearest_enemy.name)
	
	
func _get_cursor_world_position():
	var cursor_position = get_viewport().get_mouse_position()
	return $Camera.project_position(cursor_position, $Camera.translation.y)

func _find_nearest_enemy_to_cursor(cursor_position):
	var min_dist = 10000000
	var nearest_enemy: Spatial
	for enemy in enemies:
		var distance = enemy.translation.distance_to(cursor_position)
		if distance < min_dist:
			min_dist = distance
			nearest_enemy = enemy
	return nearest_enemy

func _input(event):
	if event is InputEventKey:
		if event.is_pressed() \
		and event.get_scancode_with_modifiers() == KEY_Q \
		and not event.is_echo():
			player.dash(enemies[randi() % len(enemies)])

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
