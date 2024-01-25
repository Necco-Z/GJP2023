class_name BaristaEvent
extends Resource


@export var dialogic_timeline : DialogicTimeline

@export var drink_request : DrinkRequest


func open_start_dialogue() -> void:
	Dialogic.start(dialogic_timeline)


func open_success_dialogue() -> void:
	Dialogic.start(dialogic_timeline, "SUCCESS")


func open_failure_dialogue() -> void:
	Dialogic.start(dialogic_timeline, "FAILURE")


func receive_drink(drink : DrinkRecipe) -> void:
	var result = drink_request.try_fulfill_request(drink)

	if result:
		open_success_dialogue()
	else:
		open_failure_dialogue()


func _debug_receive_drink(is_success : bool) -> void:
	if is_success:
		open_success_dialogue()
	else:
		open_failure_dialogue()

