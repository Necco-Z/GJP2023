extends Node

@export var timeline_delay := 2.0

var timeline_list := ["ivan", "vitoria"]
var current_timeline := ""
var dialog : Node

@onready var interface = $UI/MainInterface


func _ready() -> void:
	MusicPlayer.set_current($Music)
	interface.connect("drink_delivered", _on_drink_delivered)
	_get_new_timeline()


func show_interface() -> void:
	dialog.queue_free()
	interface.show_interface()
#	await $UI/MainInterface.interface_hidden


func hide_interface() -> void:
	$UI/MainInterface.hide_interface()


func call_event(event: String) -> void:
	match event:
		"vitoria":
			# TODO: Adicionar evento
			await get_tree().create_timer(1).timeout
			Dialogic.start("vitoria", "Event")


func _get_new_timeline() -> void:
	if timeline_list.size() > 0:
		await get_tree().create_timer(timeline_delay).timeout
		current_timeline = timeline_list.pop_front()
		dialog = Dialogic.start(current_timeline)
	else:
		await get_tree().create_timer(timeline_delay).timeout
		Loader.load_scene("res://ui/main_menu.tscn")


func _on_drink_delivered() -> void:
	Dialogic.start(current_timeline, "Continue")


func _on_character_finished() -> void:
	Dialogic.VAR.current_drink = ""
	_get_new_timeline()
