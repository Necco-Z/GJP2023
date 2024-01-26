extends Node


var sfx_players : Array[AudioStreamPlayer] = []


func play_sfx(sfx_name):
	var audio = load_sfx(sfx_name)
	if not audio: 
		return
	
	var player = AudioStreamPlayer.new()
	player.bus = "SFX"
	player.stream = audio
	
	sfx_players.append(player)
	player.finished.connect(_on_sfx_player_finished.bind(player))
	add_child(player)
	player.play()


## [code]sfx_name[/code] DEVE incluir o tipo de arquivo, como [code]"ok.ogg"[/code]
func load_sfx(sfx_name : String) -> AudioStream:
	return load_audio(sfx_name, "res://assets/sfx/")


func load_audio(file_name:String, base_folder:String) -> AudioStream:
	var path : String = base_folder + file_name
	var audio : AudioStream = load(path)
	if not audio:
		print_debug("WARN: Couldn't load audio file `%s` in `%s`" % [file_name, base_folder])
		return null
	
	return audio


func _ready():
	_preload_sfx()


func _preload_sfx() -> void:
	load_sfx("click_2.mp3")


func _on_sfx_player_finished(player : AudioStreamPlayer) -> void:
	sfx_players.erase(player)
	player.queue_free()


func _input(event):
	if event is InputEventKey:
		#_debug_input(event as InputEventKey)
		pass


func _debug_input(key_event : InputEventKey):
	if key_event.keycode == KEY_S:
		if randf() > 0.5:
			play_sfx("click_2.mp3")
		else:
			play_sfx("click_1.mp3")
