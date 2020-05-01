extends Spatial

var harmful: SpatialMaterial = preload("res://materials/harmful.tres")
var harmles: SpatialMaterial = preload("res://materials/harmles.tres")

export (float) var speed
export (float) var mutationChanse

var active: bool = false
var mutated: bool = false
var player: Spatial
onready var body = $Body


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	body.material = harmful
	
func activate():
	active = true
	
func isMutated():
	return mutated
	
func set_player(player: Spatial):
	self.player = player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active:
		_move(delta)
		_mutate()
	

func _move(delta):
	var direction = (player.translation - translation).normalized()
	transform = transform.translated(direction * speed * (delta/1000))
	

func _mutate():
	if !mutated:
		var distance = (player.translation - translation).length()
		var rand = randf()
		#print(rand)
		if distance < 5 and rand <= mutationChanse:
			mutated = true
			body.material = harmles

func highlight():
	body.material = null
	
