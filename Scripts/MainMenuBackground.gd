extends Spatial

onready var spawner_script = load("res://Scripts/spawner.gd")
onready var player_scene = load("res://Scenes/Player.tscn")
onready var enemy_scene = load("res://Scenes/Enemy.tscn")

var spawner
var player: Spatial

var mutation_timer: Timer
var fire_timer: Timer
var spawn_timer: Timer

signal force_mutate


func _ready():
	spawner = spawner_script.new(player_scene, enemy_scene)
	player = spawner.spawn_player(self, Vector3(0, 0, 0))
	
	player.get_node("PlayerBody").get_node("Pointer").visible = false
	player.projectile_lifetime = 10
	player.projectile_count = 9
	player.invincible = true
	
	mutation_timer = Timer.new()
	fire_timer = Timer.new()
	spawn_timer = Timer.new()
	
	fire_timer.connect("timeout", player, "fire")
	spawn_timer.connect("timeout", self, "spawn")
	
	add_child(mutation_timer)
	add_child(fire_timer)
	add_child(spawn_timer)
	
	spawn_timer.start(5)
	fire_timer.start(0.5)
	
	spawn()
	
func _process(delta):
	player.get_node("PlayerBody").rotate(Vector3(0, 1, 0), 1 * delta)

func spawn():
	spawner.spawn_enemies(self, 5, player)
	
