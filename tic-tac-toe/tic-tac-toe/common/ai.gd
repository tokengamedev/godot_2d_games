## AI class to handle the AI logic
class_name AI extends RefCounted

const Marker = Global.Marker

var game: Game
var marker: Marker
var op_marker: Marker

func _init(current_game: Game, ai_marker: Marker) -> void:
	game = current_game
	marker = ai_marker
	op_marker = Marker.X if marker == Marker.O else Marker.O

## Calculates the move and returns the index it can place.
## If no place found then returns -1
func calculate_move() -> int:
	# find winnable position
	var location = get_winnable_location()
	print("Winnable Location:", location)
	# find defendable position
	if location == -1:
		location = get_defendable_location()
		print("Defendable Location:", location)

		# find a random location
		if location == -1:
			location = get_random_location()
			print("Random Location:", location)

	return location


## Find a location to win the game
func get_winnable_location():
	return _get_win_location_for_mark(marker)


## Find a location to stop opponent from winning
func get_defendable_location():
	return _get_win_location_for_mark(op_marker)


## Finds a Random location to fill
func get_random_location() -> int:
	var indices :Array[int] = []
	for index in game.game_board.size():
		if game.game_board[index] == Marker.EMPTY:
			indices.push_back(index)
	if indices.size() > 0:
		return indices.pick_random()
	return -1


## Internal method to find the winnable location for the mark
func _get_win_location_for_mark(mark: Marker):
	var marks = game.game_board
	if marks.count(mark) < 2:
		return -1
	for path in Game.WIN_PATHS:
		if marks[path[0]] == mark and marks[path[1]] == mark and marks[path[2]] == Marker.EMPTY:
			return path[2]
		elif marks[path[1]] == mark and marks[path[2]] == mark and marks[path[0]] == Marker.EMPTY:
			return path[0]
		elif marks[path[2]] == mark and marks[path[0]] == mark and marks[path[1]] == Marker.EMPTY:
			return path[1]
	return -1
