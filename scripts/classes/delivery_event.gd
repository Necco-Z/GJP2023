class_name DeliveryEvent
extends Resource

## Usado apenas para quesitos
@export var event_name : String

## A linha do tempo Dialogic contendo o texto da cena desse evento.
@export var dialogic_timeline : DialogicTimeline

## Uma lista de strings com os nomes de todas as flags que devem
## estar ativas para esse evento acontecer. Não checamos por flags desativadas.
@export var condition_flags : Array[String]

## Se um evento é contínuo, ele irá sobrescrever o resultado
## dos eventos anteriores a ele enquanto as condições forem obedecidas. [br]
## Senão, ele criará uma nova flag para dizer que esse evento já aconteceu,
## e não poderá mais ser repetido.
@export var is_continuous : bool = true

## Uma lista de strings com os nomes de todas as flags que serão
## ativadas por esse evento.
@export var flags_to_activate : Array[String]

## Uma lista de strings com os nomes de todas as flags que serão
## desativadas por esse evento.
@export var flags_to_deactivate : Array[String]


func get_self_flag_name() -> String:
	var path := resource_path
	var event_name = path.split("/")[-1] # filename.tres
	var flag_name = "delievent_" + event_name + "_done"
	return flag_name

# TODO: implementar a mudança de flags no player data
func are_conditions_met() -> bool:
	#if not is_continuous:
	#	if get_self_flag_name() flag is on: return false
	#for flag in condition_flags:
	#	if flag is off: return false
	return true


func run() -> void:
	# for flag in flags_to_activate: turn on flag
	# for flag in flags_to_deactivate: turn off flag
	# turn on flag get_self_flag_name()
	return
