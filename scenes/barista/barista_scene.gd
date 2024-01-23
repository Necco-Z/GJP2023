class_name BaristaScene
extends Node3D


## No futuro, carregar eventos proceduralmente de uma pasta dependendo do dia.
## Também fazer um vetor de eventos.
@export var barista_event : BaristaEvent

## Para qual cena ir após os eventos dessa cena?
## Para testes, voltar ao título.
@export var next_scene : PackedScene

var is_drink_delivered : bool = false

@onready var brewing_interface = $Interfaces/OldBrewingInterface

func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal_event)
	Dialogic.timeline_ended.connect(_on_dialogic_timeline_ended)
	brewing_interface.connect("drink_delivered", _on_drink_delivered)
	
	MusicPlayer.set_current($Music)
	start_events()


func _on_dialogic_signal_event(argument : String) -> void:
	match argument:
		"brewing":
			brewing_interface.show_interface()


func _on_dialogic_timeline_ended() -> void:
	print_debug("fim da timeline")
	## TODO: alguns eventos podem não requerir drinks (motivos de plot)
	## Decidir uma forma de tratar esses eventos (por exemplo, ligar a flag pelo dialogic)
	# se não houve entrega de drink, 
	if is_drink_delivered:
		#do_next_event
		print_debug("indo pra próxima")
		finish_scene()


func _on_drink_delivered(drink : DrinkRecipe) -> void:
	barista_event.receive_drink(drink)
	is_drink_delivered = true
	#brewing_interface.hide_interface()


func _input(input_event):
	if input_event is InputEventKey:
		var key_event = input_event as InputEventKey
		_debug_key_input(key_event)



func start_events() -> void:
	# mudar pra fazer um loop pra rodar todos os eventos
	is_drink_delivered = false
	barista_event.open_start_dialogue()


func finish_scene() -> void:
	Loader.load_scene_from_packed(next_scene)


func play_character_animation(char_index : int, animation_name : String) -> void:
	pass


func _debug_key_input(key_event : InputEventKey):
	if not key_event.pressed: return
	if key_event.echo: return
	
	if key_event.keycode == KEY_F:
		barista_event._debug_receive_drink(false)
		is_drink_delivered = true
	elif key_event.keycode == KEY_G:
		barista_event._debug_receive_drink(true)
		is_drink_delivered = true

