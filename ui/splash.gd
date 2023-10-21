extends Control
# Automated splash screen
# Cycles through every child of the "Logos" node at a fixed duration
@export_file("*.tscn") var next_scene

@onready var tween = create_tween()

func _ready() -> void:
	var _t
	_t = tween.tween_interval(1.0)
	for c in $Logos.get_children():
		c.modulate = Color(1, 1, 1, 0)
		c.visible = true
		_t = tween.tween_property(c, "modulate", Color.WHITE, 0.5)
		_t = tween.tween_interval(1.0)
		_t = tween.tween_property(c, "modulate", Color.TRANSPARENT, 0.5)
		if c != $Logos.get_child($Logos.get_child_count() - 1):
			_t = tween.tween_interval(0.5)
	_t = tween.tween_interval(1.0)
	await tween.finished
	_t = get_tree().change_scene_to_file(next_scene)
