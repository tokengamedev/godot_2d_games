## Starting point for the game. Based on the game selection different scenes will be launched
extends Control

func _on_multi_player_button_pressed() -> void:
	Global.game_type = Global.GameType.WITH_FRIENDS
	get_tree().change_scene_to_file("res://main_scene/lobby_scene.tscn")
	Lobby.initialize()


func _on_single_player_button_pressed() -> void:
	Global.game_type = Global.GameType.WITH_AI
	get_tree().change_scene_to_file("res://main_scene/launcher_scene.tscn")
	Lobby.initialize()
