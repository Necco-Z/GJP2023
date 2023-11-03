@tool
extends Button

@export var button_icon: Texture2D:
	set = _set_button_icon
@export var icon_margin := 5:
	set = _set_icon_margin
@export var drink_name: String:
	set = _set_drink_name


func _set_button_icon(value: Texture2D) -> void:
	if value:
		text = ""
	else:
		text = drink_name
	button_icon = value
	$Icon.texture = value


func _set_icon_margin(value: int) -> void:
	value = max(0, value)
	icon_margin = value
	$Icon.offset_left = value
	$Icon.offset_top = value
	$Icon.offset_right = -value
	$Icon.offset_bottom = -value


func _set_drink_name(value: String) -> void:
	drink_name = value
	if button_icon:
		text = ""
	else:
		text = drink_name

