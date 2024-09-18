## Dialog to display pause or Game Over Scene
class_name OverlayDialog extends Control

signal continue_game
signal new_game
signal exit

@onready var background: MarginContainer = $Background
@onready var header_text: Label = %HeaderText
@onready var winner_text: Label = %WinnerText
@onready var play_button: TextureButton = %PlayButton
@onready var continue_button: TextureButton = %ContinueButton

enum DialogContext { PAUSE, GAME_OVER }
var context := DialogContext.GAME_OVER

func _ready() -> void:

	background.anchor_left = 1.05
	background.anchor_right = 1.65

func _update(text: String =""):
	winner_text.text = text
	if context == DialogContext.GAME_OVER:
		play_button.visible = true
		continue_button.visible = false
		header_text.text = "GAME OVER"
		winner_text.visible = true
	else:
		play_button.visible = false
		continue_button.visible = true
		header_text.text = "PAUSED"
		winner_text.visible = false


func show_dialog(display_context: DialogContext = DialogContext.PAUSE, center_text:String = ""):
	context = display_context
	_update(center_text)
	self.visible = true
	var tween = create_tween().set_parallel()
	tween.tween_property(background, "anchor_left", 0.25, 0.8).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(background, "anchor_right", 0.75, 0.8).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)


func hide_dialog():
	var tween = create_tween().set_parallel()
	tween.tween_property(background, "anchor_left", 1.05, 0.8).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tween.tween_property(background, "anchor_right", 1.55, 0.8).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	await tween.finished
	self.visible = false


func _on_continue_button_pressed() -> void:
	continue_game.emit()


func _on_play_button_pressed() -> void:
	new_game.emit()


func _on_exit_button_pressed() -> void:
	exit.emit()
