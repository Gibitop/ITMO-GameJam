extends Spatial

var harmful: SpatialMaterial = preload("res://materials/harmful.tres")
var harmles: SpatialMaterial = preload("res://materials/harmles.tres")
var main_scene_script = load("res://Scripts/MainScene.gd")
 
export (float) var speed
export (float) var max_mutation_distance
export (float) var max_mutation_chance

var active: bool = false
var mutated: bool = false
var player: Spatial

onready var body = $Body
onready var highlighter = $Highlighter

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	highlighter.visible = false
	body.material = harmful
	
func activate():
	active = true
	visible = true
	
func is_active():
	return active
	
func isMutated():
	return mutated
	
func set_player(player: Spatial):
	self.player = player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active:
		_move(delta)	

func _move(delta):
	var direction = (player.translation - translation).normalized()
	transform = transform.translated(direction * speed * (delta/1000))
	

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

func highlight():
	highlighter.visible = true
	
func unhighlight():
	highlighter.visible = false
	
