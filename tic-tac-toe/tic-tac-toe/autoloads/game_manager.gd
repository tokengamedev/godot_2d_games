extends Node

## raised when both players are ready to play game
signal game_started(my_turn: bool)
## raised when player placed the marker on board
signal player_move(index: int, marker: Marker)
### raised when opponent placed the marker on board
signal game_over (index: int, winner_mark: Marker, win_path: Array, is_draw: bool)

const Marker = Global.Marker

## The current game
var current_game: Game = null
var game_type := Global.GameType.WITH_AI

var player: Player
var opponent: Player

var turn_player: Player = null
var ai: AI

## Call to create the game after it is decided whioch marker who will take
func create_game(_player: Player, _opponent: Player):

	current_game = Game.new()

	self.player = _player
	self.opponent = _opponent

	if Global.is_single_player_game():
		ai = AI.new(current_game, opponent.marker)

func is_my_turn() -> bool: return turn_player == player


## Starts the game
func start_game():
	if player.marker == Marker.X:
		turn_player = opponent
	else:
		turn_player = player
	_switch_turn()
	Lobby.set_player_ready()

## Launches the game after the start is requested
func launch_game():
	game_started.emit(is_my_turn())

func debug(msg:String):
	if player.marker == Marker.X:
		print_rich("[color=lightgreen][b]%s[/b][/color]::%s" % [player.name, msg])
	else:
		print_rich("[color=orchid][b]%s[/b][/color]::%s" % [player.name, msg])



## Places the marker in the game and check for Game Completion
@rpc("any_peer", "call_local")
func place_marker(position: int, mark: Marker):
	current_game.place_mark(position, mark)
	if current_game.is_game_over:
		# game is over
		game_over.emit(	position,
						current_game.current_mark,
						current_game.game_win_path,
						current_game.state == Game.STATE.DRAW)
		return
	else:
		_switch_turn()
		player_move.emit(position, mark)
#

func _switch_turn():
	if turn_player == player:
		turn_player = opponent
		if not opponent.is_human:
			var move_position = ai.calculate_move()
			await get_tree().create_timer(0.5).timeout
			place_marker(move_position, turn_player.marker)

	else:
		turn_player = player


func complete_game():
	turn_player = null


func reset_game():
	player.marker = Marker.X if player.marker == Marker.O else Marker.O
	opponent.marker = Marker.X if opponent.marker == Marker.O else Marker.O
	current_game.reset_board()
