extends Spatial

onready var utils = preload("res://Scripts/utils.gd")
onready var player_scene = preload("res://Scenes/Player.tscn")
onready var enemy_scene = preload("res://Scenes/Enemy.tscn")
onready var spawner_script = load("res://Scripts/spawner.gd")
onready var enemy = preload("res://Scripts/Enemy.gd")

var player: Spatial
var nearest_enemy: Spatial
var mutation_timer: Timer
var spawner
var super_event_treshold = 1000

signal force_mutate

const DASH_BUTTON = BUTTON_LEFT

export (float) var auto_aim_sensitivity = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	mutation_timer = Timer.new()
	add_child(mutation_timer)
	mutation_timer.start()
	spawner = spawner_script.new(player_scene, enemy_scene)
	player = spawner.spawn_player(self, Vector3(0, 0, 0))
	player.connect("combo_changed", $HUD, "update_combo")
	player.connect("score_changed", self, "super_event")
	player.connect("money_changed", $HUD, "update_money")
	player.connect("score_changed", $HUD, "update_experience")
	player.connect("health_changed", $HUD, "update_hp")
	player.connect("energy_changed", $HUD, "update_energy")
	$HUD.update_energy(player.energy)
	$HUD.update_hp(player.health)
	
	
	spawner.spawn_enemies(self, 10, player)
	test()
	
func super_event(val):
	if val > super_event_treshold:
		super_event_treshold *= 10
		emit_signal("force_mutate")

func test():
	while true:
		yield(get_tree().create_timer(3), "timeout")
		spawner.spawn_enemies(self, 15, player)

func _process(delta):
	var cursor_position = utils.get_cursor_world_position(get_viewport(), player.get_node("Camera"))
	var new_nearest_enemy = _find_nearest_enemy_to_cursor(cursor_position)
	if new_nearest_enemy != nearest_enemy:
		if nearest_enemy:
			nearest_enemy.unhighlight()
		nearest_enemy = new_nearest_enemy
		if nearest_enemy:
			nearest_enemy.highlight()

func _find_nearest_enemy_to_cursor(cursor_position):
	var min_dist = 10000000
	var _nearest_enemy: Spatial
	for enemy in spawner.get_enemies_pool():
		if not enemy.is_active() or not enemy.isMutated(): 
			continue
		var distance = enemy.translation.distance_to(cursor_position)
		if distance < min_dist and distance < auto_aim_sensitivity:
			min_dist = distance
			_nearest_enemy = enemy
	return _nearest_enemy

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() \
		and event.get_button_index() == DASH_BUTTON \
		and not event.is_echo() \
		and nearest_enemy != null:
			player.dash(nearest_enemy)

	
func get_all_enemies():
	return spawner.get_enemies_pool()
