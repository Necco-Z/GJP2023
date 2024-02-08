extends Node

@export var timeline_delay := 2.0

var timeline_list := ["ivan", "vitoria"]
var current_timeline := ""
var dialog : Node


@export var bg : Node
@export var interface : Node


func _ready() -> void:
	MusicPlayer.set_current($Music)
	interface.connect("drink_delivered", _on_drink_delivered)
	_get_new_timeline(true)


func show_interface() -> void:
	dialog.queue_free()
	interface.show_interface()


func hide_interface() -> void:
	interface.hide_interface()


func call_event(event: String) -> void:
	match event:
		"vitoria":
			# TODO: Adicionar evento
			await get_tree().create_timer(1).timeout
			Dialogic.start("vitoria", "Event")


func _get_new_timeline(first_timeline := false) -> void:
	if timeline_list.size() > 0:
		current_timeline = timeline_list.pop_front()
		if not first_timeline:
			await get_tree().create_timer(0.8).timeout
			await Fader.fade_out()
			bg.set_char_anim(current_timeline)
			await get_tree().create_timer(0.2).timeout
			await Fader.fade_in()
		await get_tree().create_timer(timeline_delay).timeout
		dialog = Dialogic.start(current_timeline)
	else:
		await get_tree().create_timer(timeline_delay).timeout
		Loader.load_scene("res://ui/main_menu.tscn")


func _on_drink_delivered() -> void:
	Dialogic.start(current_timeline, "Continue")


func _on_character_finished() -> void:
	Dialogic.VAR.current_drink = ""
	_get_new_timeline()
