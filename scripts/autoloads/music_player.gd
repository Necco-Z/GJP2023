extends Node

var fade_time := 0.25
var current_music: AudioStreamPlayer


func set_current(music_node: AudioStreamPlayer, instant := false):
	if music_node.get_parent():
		music_node.get_parent().remove_child(music_node)
	if current_music:
		if current_music.stream == music_node.stream:
			music_node.queue_free()
			return
		if not instant:
			var tween = create_tween()
			tween.tween_property(current_music, "volume_db", linear_to_db(0), fade_time)
			await tween.finished
		current_music.queue_free()
	add_child(music_node)
	current_music = music_node
	current_music.bus = "Music"
	current_music.play()
	if not instant:
		var tween = create_tween()
		var current_db = current_music.volume_db
		current_music.volume_db = linear_to_db(0)
		tween.tween_property(current_music, "volume_db", current_db, fade_time)
		await tween.finished
