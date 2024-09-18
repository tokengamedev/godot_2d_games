## Reprsents a Button
extends TextureButton

const TEXT_COLORS := {
	true: Color("#562405"),
	false: Color("#FFD361")
}

@export var label :String = ""
@onready var text: Label = $Margin/Text


func set_enabled(value: bool):
	disabled = not value
	mouse_default_cursor_shape = CURSOR_ARROW if disabled else CURSOR_POINTING_HAND
	set_text_color()


func _ready() -> void:
	text.text = label
	set_enabled(not disabled)


func set_text_color():
	text.label_settings.font_color = TEXT_COLORS[disabled]
