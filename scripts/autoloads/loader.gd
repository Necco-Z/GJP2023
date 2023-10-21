extends Node


func load_scene(scene: String) -> void:
	await Fader.fade_out()
	get_tree().change_scene_to_file(scene)
	Fader.fade_in()
