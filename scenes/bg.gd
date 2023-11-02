extends Node3D

@onready var char_animator = $Characters/CharAnimation as AnimationPlayer


func set_char_anim(to: String) -> void:
	if char_animator.has_animation(to):
		char_animator.current_animation = to
