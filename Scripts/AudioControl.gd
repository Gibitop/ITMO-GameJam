extends Node

onready var main_menu_music = $MainMenuMusic
onready var main_scene_music = $MainSceneMusic

func _ready():
	play_menu_music()

func play_menu_music():
	main_scene_music.stop()
	main_menu_music.play()
	
func play_scene_music():
	main_menu_music.stop()
	main_scene_music.play()
