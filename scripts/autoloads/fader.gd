extends CanvasLayer

signal fade_finished

var fade_time := 0.5
var is_fading := false

@onready var color = $Color


func set_transparent(value: bool):
	if not is_fading:
		color.modulate = Color.TRANSPARENT if value else Color.WHITE


func fade_in():
	await _fade(true)


func fade_out():
	await _fade(false)


func _fade(fading_in: bool):
	var col = Color.TRANSPARENT if fading_in else Color.WHITE
	var prev = Color.WHITE if fading_in else Color.TRANSPARENT
	if not is_fading:
		is_fading = true
		color.modulate = prev
		var tween = create_tween()
		tween.tween_property(color, "modulate", col, 0.5)
		await tween.finished
		is_fading = false
		fade_finished.emit()
