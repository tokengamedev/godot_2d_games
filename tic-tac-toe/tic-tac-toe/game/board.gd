class_name GameBoard extends GridContainer

const Marker = Global.Marker

signal piece_selected(piece_index: int)


func _ready() -> void:
	for index in get_child_count():
		get_child(index).selected.connect(_on_piece_selected.bind(index))


func _on_piece_selected(_piece_name: StringName, index: int):
	piece_selected.emit(index)


func place_mark(index: int, mark: Marker ):
	if mark == Marker.X:
		get_child(index).set_state(Piece.STATE.X_FILL)
	elif mark == Marker.O:
		get_child(index).set_state(Piece.STATE.O_FILL)


func set_win_piece(indices: Array, mark: Marker):
	print(indices, " ", Marker.find_key(mark))
	var win_state = Piece.STATE.X_FILL_WIN if mark == Marker.X else Piece.STATE.O_FILL_WIN
	for index in indices:
		get_child(index).set_win_state(win_state)
		await create_tween().tween_interval(0.25).finished


func disable():
	for child in get_children():
		child.mouse_filter = MOUSE_FILTER_IGNORE

func enable():
	for child in get_children():
		child.mouse_filter = MOUSE_FILTER_STOP

func reset():
	for child in get_children():
		child.reset()
