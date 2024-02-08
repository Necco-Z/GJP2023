extends Control


func _ready() -> void:
	MusicPlayer.set_current($Music)
	Fader.set_transparent(false)
	await get_tree().create_timer(0.2).timeout
	Fader.fade_in()
	$Buttons/Start.grab_focus()
	if PlayerData.data.player_id != "":
		PlayerData.save_data()
	PlayerData.reset_data()


func _on_start_pressed() -> void:
	#Loader.load_scene("res://scenes/game_screen.tscn")
	Loader.load_scene("res://scenes/barista/barista_scene_vitoria.tscn")


func _on_exit_pressed() -> void:
	for button in $Buttons.get_children():
		button.disabled = true

	await Fader.fade_out()
	get_tree().quit()


func _on_options_pressed():
	Loader.load_scene("res://ui/menus/options_menu.tscn")
