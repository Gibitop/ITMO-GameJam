extends Control

func _on_ContinueButton_pressed():
	get_tree().paused = false
	visible = false


func _on_ToMenuButton_pressed():
	get_tree().change_scene("res://Scenes/UI/MainMenuBackground.tscn")
