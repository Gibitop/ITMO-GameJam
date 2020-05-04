extends Control

func _on_Button_pressed():
	get_parent().get_node("MainMenu").visible = true
	visible = false
