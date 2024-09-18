extends Control

const Marker := Global.Marker

const OPPONENT_TEXTURES := {
	true : preload("res://assets/images/human-opponent.png"),
	false : preload("res://assets/images/ai-opponent.png")
}
@onready var turn_label: Label = %TurnLabel
@onready var board: GameBoard = %Board

@onready var pause_button: TextureButton = %PauseButton
@onready var opponent_name: Label = %OpponentName
@onready var opponent_image: TextureRect = %OpponentImage
@onready var overlay_dialog: OverlayDialog = $OverlayDialog
@onready var waiting_dialog: ColorRect = $WaitingDialog

var show_waiting := false

func _ready() -> void:
	GameManager.game_started.connect(handle_game_start)
	GameManager.game_over.connect(handle_game_over)
	GameManager.player_move.connect(handle_player_move)
	#GameManager.opponent_move.connect(handle_opponent_move)

	overlay_dialog.continue_game.connect(handle_unpause_game)
	overlay_dialog.new_game.connect(handle_new_game)
	overlay_dialog.exit.connect(handle_exit)

	waiting_dialog.timeout.connect(handle_player_connection_timeout)

	board.piece_selected.connect(_on_piece_selected)
	board.disable()

	set_opponent_data()

	GameManager.start_game()

	if not Lobby.ready_to_launch():
		waiting_dialog.show_dialog()

func set_opponent_data():
	opponent_image.texture = OPPONENT_TEXTURES[GameManager.opponent.is_human]
	opponent_name.text = GameManager.opponent.name

func handle_player_connection_timeout():
	Lobby.disconnect_player()
	print("disconnecting player")


## called when game is ready to start i.e., both the player started
func handle_game_start(my_turn: bool):
	waiting_dialog.close_dialog()
	GameManager.debug("TURN = " + str(my_turn))
	switch_turn(my_turn)


func switch_turn(my_turn: bool):
	if my_turn:
		turn_label.text = "Your Turn"
		board.enable()
	else:
		turn_label.text = GameManager.opponent.name + "'s Turn"
		board.disable()


func handle_player_move(index: int, marker:Marker):
	board.place_mark(index, marker)
	switch_turn(GameManager.is_my_turn())


## Called when player selected the cell to place mark
func _on_piece_selected(index: int):
	GameManager.place_marker.rpc(index, GameManager.player.marker)


func handle_game_over(location: int , mark: Marker, win_path: Array, is_draw: bool):

	turn_label.text = "Game Over"
	board.disable()
	board.place_mark(location, mark)
	await create_tween().tween_interval(0.3).finished
	if not is_draw:
		board.set_win_piece(win_path, mark)
		await create_tween().tween_interval(1.2).finished
		overlay_dialog.visible = true

	var win_text ="Draw"
	if not is_draw:
		if mark == GameManager.player.marker:
			win_text = "You Won"
		else:
			win_text = "You Lost"
	overlay_dialog.show_dialog(OverlayDialog.DialogContext.GAME_OVER, win_text)


func _on_pause_button_pressed() -> void:
	pause_game.rpc(true)


func handle_unpause_game():
	pause_game.rpc(false)

@rpc("any_peer", "call_local")
func pause_game(will_pause: bool):
	if will_pause:
		board.disable()
		overlay_dialog.show_dialog(OverlayDialog.DialogContext.PAUSE)
	else:
		if GameManager.is_my_turn():
			board.enable()
		overlay_dialog.hide_dialog()

func handle_new_game():
	reset_game.rpc()

@rpc("any_peer", "call_local")
func reset_game():
	board.reset()
	overlay_dialog.hide_dialog()
	GameManager.reset_game()
	GameManager.start_game()


func handle_exit():
	exit_game.rpc()
	Lobby.clear_players.rpc()


@rpc("any_peer", "call_local")
func exit_game():
	get_tree().change_scene_to_file("res://main_scene/main_scene.tscn")
