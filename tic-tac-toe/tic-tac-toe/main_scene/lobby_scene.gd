extends Control

@onready var player_name_edit: LineEdit = %PlayerNameEdit
@onready var start_game_button: TextureButton = %StartGameButton
@onready var join_game_button: TextureButton = %JoinGameButton
@onready var status_text: Label = %StatusText

func _enter_tree() -> void:
	Global.game_type = Global.GameType.WITH_FRIENDS
	Lobby.host_created.connect(_on_host_created)
	Lobby.particpant_created.connect(_on_participant_created)
	Lobby.opponent_connected.connect(_on_opponent_joined)
	Lobby.opponent_disconnected.connect(_on_opponent_left)


func _ready() -> void:
	status_text.text = ""
	player_name_edit.text = _get_random_name()


func _on_start_game_button_pressed() -> void:
	player_name_edit.editable = false
	start_game_button.set_enabled(false)
	join_game_button.set_enabled(false)
	Lobby.create_mp_host(player_name_edit.text)


func _on_join_game_button_pressed() -> void:
	player_name_edit.editable = false
	start_game_button.set_enabled(false)
	join_game_button.set_enabled(false)
	Lobby.create_mp_participant(player_name_edit.text)

func _on_host_created():
	status_text.text = "Game Started...waiting for participant"


func _on_participant_created():
	status_text.text = "Joined Lobby...waiting for host"


func _on_opponent_joined():
	status_text.text = "Players connected [%s vs %s]" % [Lobby.player.name, Lobby.opponent.name]
	# goto next scene for Game Creation and Marker decision
	goto_launcher_scene.rpc()

func _on_opponent_left():
	if Lobby.game.player.is_host:
		status_text.text = "Particpant disconnected...waiting for participant"
	else:
		status_text.text = "Host disconnected...waiting for host"


## Gets a random name for the player
func _get_random_name(): return "Player%03d" % (randi() % 100)


@rpc("any_peer")
func goto_launcher_scene():
	get_tree().change_scene_to_file("res://main_scene/launcher_scene.tscn")
