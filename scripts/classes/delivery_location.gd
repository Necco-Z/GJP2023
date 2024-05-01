class_name DeliveryLocation
extends Resource

enum DeliveryType { NONE=0, INTEL=1, PLACE=2, PEOPLE=3}

## Nome a ser mostrado na interface.
@export var name : String = "Loc. Name"

## Descrição curta para mostrar na interface.
@export_multiline var description : String = ""

@export_category("Eventos - Pegar Informação")
## Lista de todos os eventos que podem ocorrer nesse local ao selecionar
## "Pegar Informação". [br][br]
## É uma lista de prioridade, com o primeiro elemento sendo de menor prioridade,
## e o ultimo de maior prioridade. Se um evento de maior prioridade for cumprido,
## o resto dos eventos de menor prioridade serão ignorados.
@export var intel_events : Array[DeliveryEvent] = []

@export_category("Eventos - Afetar Local")
## Lista de todos os eventos que podem ocorrer nesse local ao selecionar
## "Afetar Local". [br][br]
## É uma lista de prioridade, com o primeiro elemento sendo de menor prioridade,
## e o ultimo de maior prioridade. Se um evento de maior prioridade for cumprido,
## o resto dos eventos de menor prioridade serão ignorados.
@export var place_events : Array[DeliveryEvent] = []

@export_category("Eventos - Afetar Pessoa")
## Lista de todos os eventos que podem ocorrer nesse local ao selecionar
## "Afetar Pessoa". [br][br]
## É uma lista de prioridade, com o primeiro elemento sendo de menor prioridade,
## e o ultimo de maior prioridade. Se um evento de maior prioridade for cumprido,
## o resto dos eventos de menor prioridade serão ignorados.
@export var people_events : Array[DeliveryEvent] = []


func run_events(mission_type: int) -> void:
	var events_list : Array[DeliveryEvent] = []
	match mission_type:
		DeliveryType.INTEL:
			events_list = intel_events.duplicate()
		DeliveryType.PLACE:
			events_list = place_events.duplicate()
		DeliveryType.PEOPLE:
			events_list = people_events.duplicate()
	
	events_list.reverse()
	for event : DeliveryEvent in events_list:
		if event.are_conditions_met():
			event.run()
			break # eventos sobrescrevem outros eventos
