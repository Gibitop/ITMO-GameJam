extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_PlayButton_pressed():
#	get_tree().paused = false
	get_node("/root/AudioPlayer").play_scene_music()
	get_tree().change_scene("res://Scenes/MainScene.tscn")


func _on_ExitButton_pressed():
	get_tree().quit(0)


func _on_ExitButton3_pressed():
	get_parent().get_node("RPG").visible = true
	visible = false


func _on_ExitButton2_pressed():
	get_parent().get_node("Tutorial").visible = true
	visible = false
#	get_tree().change_scene("res://Scenes/UI/Tutorial.tscn")
