extends RigidBody

var harmful: SpatialMaterial = preload("res://materials/harmful.tres")
var harmles: SpatialMaterial = preload("res://materials/harmles.tres")
var main_scene_script = load("res://Scripts/MainScene.gd")
 
export (float) var speed
export (float) var max_mutation_distance
export (float) var max_mutation_chance
export (float) var arena_radius

var active: bool = false
var mutated: bool = false
var player: Spatial

var spawner
var pool_index: int

onready var body = $Body
onready var highlighter = $Highlighter

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	highlighter.visible = false
	
func activate():
	active = true
	visible = true
	mutated = false
	$OmniLight.light_color = Color(1, 0, 0)
	body.material = harmful
	
func is_active():
	return active
	
func isMutated():
	return mutated
	
func set_player(player: Spatial):
	self.player = player

func _process(delta):
	if translation.length() > arena_radius and active:
		kill()


func _physics_process(delta):
	if active:
		pass
		_move(delta)

func _move(delta):
	var direction = (player.translation - translation).normalized()
#	transform = transform.translated(direction * speed * (delta/1000))
	
	add_central_force(direction * speed * delta)

func _mutate():
	if !mutated and active:
		var distance = (player.translation - translation).length()
		var chance = (max_mutation_chance * max(1 - distance / max_mutation_distance, 0))
		if randf() <= chance:
			mutated = true
			body.material = harmles
			
func kill():
	active = false
	visible = false
	highlighter.visible = false
	translation = Vector3(200, 200, 200)
	set_axis_velocity(Vector3(0, 0, 0))
	spawner.on_enemy_death(pool_index)

func highlight():
	$OmniLight.light_color = Color(1, 1, 1)
#	highlighter.visible = true
	
func unhighlight():
	$OmniLight.light_color = Color(0, 1, 0)
#	highlighter.visible = false

func set_pool_index(ind):
	pool_index = ind

func get_pool_index():
	return pool_index
	
func set_spawner(_spawner):
	spawner = _spawner
	
