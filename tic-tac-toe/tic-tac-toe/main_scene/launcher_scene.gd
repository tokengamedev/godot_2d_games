extends Control


const Marker := Global.Marker

@onready var markers: Control = $Markers
@onready var x_mark: TextureRect = $Markers/XMark
@onready var o_mark: TextureRect = $Markers/OMark
@onready var display: Label = $DisplayText
@onready var start_button: TextureButton = $StartButton

#var decided_mark := Marker.EMPTY
var toss_tween: Tween
const MIN_TOSS_COUNT = 1
var toss_count := 0


func _ready() -> void:
	x_mark.modulate.a = 0.0
	o_mark.modulate.a = 0.0
	display.text = "Deciding Marker..."
	visible = true

	show_marker_animation()

	#randomize()

func show_marker_animation():

	toss_tween = create_tween().set_loops()
	toss_tween.loop_finished.connect(decide_marker)
	toss_tween.tween_property(x_mark,"modulate:a", 1.0, 0.6).set_ease(Tween.EASE_IN_OUT)
	toss_tween.tween_property(x_mark,"modulate:a", 0.0, 0.6).set_ease(Tween.EASE_IN_OUT)
	toss_tween.tween_property(o_mark,"modulate:a", 1.0, 0.6).set_ease(Tween.EASE_IN_OUT)
	toss_tween.tween_property(o_mark,"modulate:a", 0.0, 0.6).set_ease(Tween.EASE_IN_OUT)


func decide_marker(loop_count : int):
	if Lobby.is_player_host():
		print("Loop Count =", loop_count)
		if loop_count < MIN_TOSS_COUNT:
			return
		else:
			set_marker(randi() % 2 + 1)


@rpc
func set_marker(marker_value: int):
	var decided_mark = 	marker_value as Marker
	var opposite_mark = Marker.X if decided_mark == Marker.O else Marker.O
	toss_tween.kill()

	var tween: Tween
	if decided_mark == Marker.X:
		tween = create_tween()
		tween.tween_property(x_mark,"modulate:a", 1.0, 0.6).set_ease(Tween.EASE_IN_OUT)
	else:
		tween = create_tween()
		tween.tween_property(o_mark,"modulate:a", 1.0, 0.6).set_ease(Tween.EASE_IN_OUT)

	start_button.set_enabled(true)
	display.text = "Your Mark"
	Lobby.create_game(decided_mark, opposite_mark)

	if Lobby.is_player_host():
		set_marker.rpc(opposite_mark as int)

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://game/game_scene.tscn")
