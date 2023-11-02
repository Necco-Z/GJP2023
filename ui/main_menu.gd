extends Control


func _ready() -> void:
	MusicPlayer.set_current($Music)
	Fader.set_transparent(false)
	await get_tree().create_timer(0.2).timeout
	Fader.fade_in()


func _on_start_pressed() -> void:
	Loader.load_scene("res://scenes/game_screen.tscn")


func _on_exit_pressed() -> void:
	await Fader.fade_out()
	get_tree().quit()
