## Reprsents a Piece of the Board
class_name Piece extends MarginContainer

signal selected

enum STATE {EMPTY, X_FILL, O_FILL, X_FILL_WIN, O_FILL_WIN}

const MARKERS :={
	STATE.EMPTY: preload("res://assets/images/empty_hover.png"),
	STATE.X_FILL: preload("res://assets/images/x_piece.png"),
	STATE.O_FILL: preload("res://assets/images/o_piece.png"),
	STATE.X_FILL_WIN: preload("res://assets/images/x_win_piece.png"),
	STATE.O_FILL_WIN: preload("res://assets/images/o_win_piece.png")
}

var state := STATE.EMPTY: set = set_state
@onready var marker: TextureRect = $Marker
@onready var win_marker: TextureRect = $WinMarker

func reset():
	state = STATE.EMPTY
	marker.modulate.a = 0.0
	win_marker.modulate.a = 0.0


func set_state(new_state: STATE):
	if new_state != state:
		state = new_state
		marker.texture = MARKERS[state]
		if new_state != STATE.EMPTY:
			marker.modulate.a = 0.0

			var tween = create_tween()
			tween.tween_property(marker,"modulate:a", 1, 0.4)


func set_win_state(new_state: STATE):
	win_marker.texture = MARKERS[new_state]
	var tween = create_tween()
	tween.tween_property(win_marker,"modulate:a", 1, 0.25)


func _ready() -> void:
	marker.modulate.a = 0.0
	win_marker.modulate.a = 0.0


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		if get_global_rect().has_point(event.global_position):
			selected.emit(name)


func _on_mouse_entered() -> void:
	if state == STATE.EMPTY:
		var tween = create_tween()
		tween.tween_property(marker,"modulate:a", 0.75, 0.1)


func _on_mouse_exited() -> void:
	if state == STATE.EMPTY:
		var tween = create_tween()
		tween.tween_property(marker,"modulate:a", 0.0, 0.1)
