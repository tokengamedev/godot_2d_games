## Game class to hold the state of the Game
class_name Game extends RefCounted

const Marker = Global.Marker

enum STATE { PLAYING, WINNER, DRAW }

var game_board: Array[Marker] = [	Marker.EMPTY, Marker.EMPTY, Marker.EMPTY,
								Marker.EMPTY, Marker.EMPTY, Marker.EMPTY,
								Marker.EMPTY, Marker.EMPTY, Marker.EMPTY ]

const WIN_PATHS := [
	[0, 1, 2], [3, 4, 5], [6, 7, 8], # Rows
	[0, 3, 6], [1, 4, 7], [2, 5, 8], # Columns
	[0, 4, 8], [2, 4, 6] # Diagonal
]

## True if game is over else false
var is_game_over := false

## Holds the state of the game
var state := STATE.PLAYING

## Holds the win index path of the winning cells
var game_win_path := [-1, -1, -1]

## The marker that wins
var current_mark: Marker = Marker.EMPTY

## resets the game to clear all the values
func reset_board():
	for index in game_board.size():
		game_board[index] = Marker.EMPTY

	is_game_over = false
	game_win_path.fill(-1)
	current_mark = Marker.EMPTY
	state = STATE.PLAYING


## Places the given mark at the given location. It also marks is_game_over flag if the game is over
func place_mark(index: int, mark: Marker):
	game_board[index] = mark

	#move_count += 1
	_check_game_over(mark)


func _check_game_over(mark: Marker):
	for win_path in WIN_PATHS:
		if game_board[win_path[0]] == mark:
			if (game_board[win_path[1]] == game_board[win_path[0]] and
				game_board[win_path[1]] == game_board[win_path[2]]):

				state = STATE.WINNER
				current_mark = mark
				is_game_over = true
				game_win_path.assign(win_path)
				return

	# check if there is any empty piece
	for cell_mark in game_board:
		if cell_mark == Marker.EMPTY:
			return

	state = STATE.DRAW
	is_game_over = true
	current_mark = mark


func _to_string() -> String:
	return " %s | %s | %s \n %s | %s | %s \n %s | %s | %s " % game_board.map(
	func _mapper(v):
		match(v):
			Marker.X: return "X"
			Marker.O: return "O"
			_: return "-"
		)
