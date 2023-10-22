extends Node

var timeline_list := ["ivan", "vitoria"]
var current_timeline := ""

@onready var interface = $UI/MainInterface


func _ready() -> void:
	interface.connect("drink_delivered", _on_drink_delivered)
	_get_new_timeline()


func show_interface() -> void:
	interface.show_interface()
#	await $UI/MainInterface.interface_hidden


func hide_interface() -> void:
	$UI/MainInterface.hide_interface()


func _get_new_timeline() -> void:
	if timeline_list.size() > 0:
		current_timeline = timeline_list.pop_front()
		Dialogic.start(current_timeline)



func _on_drink_delivered() -> void:
	Dialogic.start(current_timeline, "Continue")


func _on_character_finished() -> void:
	Dialogic.VAR.current_drink = ""
	_get_new_timeline()
