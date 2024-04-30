class_name DeliveryLocation
extends Resource

## Nome a ser mostrado na interface.
@export var name : String = "Loc. Name"

## Descrição curta para mostrar na interface.
@export_multiline var description : String = ""

## Lista de todos os eventos que podem ocorrer nesse local. [br][br]
## É uma lista de prioridade, com o primeiro elemento sendo de menor prioridade,
## e o ultimo de maior prioridade. Se um evento de maior prioridade for cumprido,
## o resto dos eventos de menor prioridade serão ignorados.
@export var delivery_events : Array[DeliveryEvent] = []


func run_events() -> void:
	var events_list = delivery_events.duplicate()
	events_list.reverse()
	for event : DeliveryEvent in events_list:
		if event.are_conditions_met():
			event.run()
			break # eventos sobrescrevem outros eventos
