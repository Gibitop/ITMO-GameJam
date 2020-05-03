extends Control

func _on_ContinueButton_pressed():
	get_tree().paused = false
	visible = false


func _on_ToMenuButton_pressed():
	get_tree().change_scene("res://Scenes/UI/MainMenu.tscn")

func _input(event):
	if event is InputEventKey:
		if event.is_pressed() \
		and event.get_scancode_with_modifiers() == KEY_ESCAPE \
		and not event.is_echo() \
		and get_tree().paused:
			_on_ContinueButton_pressed()
