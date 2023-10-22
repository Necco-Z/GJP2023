extends Node


func _ready() -> void:
	Dialogic.start("test_timeline")


func show_interface() -> void:
	$UI/MainInterface.show_interface()
#	await $UI/MainInterface.interface_hidden

func hide_interface() -> void:
	$UI/MainInterface.hide_interface()

