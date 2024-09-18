extends ColorRect

signal timeout

@export var wait_time := 60
@onready var time_left: Label = $Center/VBoxContainer/TimeLeft
@onready var wait_timer: Timer = $WaitTimer

var time_remaining := 0
var timeout_happened := false

func show_dialog():
	self.modulate.a = 0.0
	self.visible = true
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 1.0).set_ease(Tween.EASE_OUT)
	await tween.finished
	time_remaining = wait_time
	time_left.text = str(time_remaining)
	wait_timer.start()


func close_dialog():
	if not wait_timer.is_stopped():
		wait_timer.stop()
	if visible:
		var tween = create_tween()
		tween.tween_property(self, "modulate:a", 0.0, 1.0).set_ease(Tween.EASE_OUT)
		await tween.finished
	_close()


func _on_wait_timer_timeout() -> void:
	time_remaining -= 1
	time_left.text = str(time_remaining)
	if time_remaining == 0:
		timeout_happened = true
		close_dialog()


func _close():
	self.visible = false
	if timeout_happened:
		timeout.emit()
