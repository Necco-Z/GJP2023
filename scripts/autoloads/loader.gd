extends Node

var shader_stack_packed : PackedScene = preload("res://scenes/screenspace_shader_stack.tscn")


func _ready():
	get_tree().root.add_child(shader_stack_packed.instantiate())


func load_scene(scene: String) -> void:
	await Fader.fade_out()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file(scene)
	Fader.fade_in()
