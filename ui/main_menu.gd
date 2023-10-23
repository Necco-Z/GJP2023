extends Control


func _ready() -> void:
	MusicPlayer.set_current($Music)


func _on_start_pressed() -> void:
	Loader.load_scene("res://scenes/game_screen.tscn")


func _on_exit_pressed() -> void:
	await Fader.fade_out()
	get_tree().quit()
