class_name BaristaScene
extends Node3D


## No futuro, carregar eventos proceduralmente de uma pasta dependendo do dia.
## Também fazer um vetor de eventos.
@export var barista_event : BaristaEvent

## Para qual cena ir após os eventos dessa cena?
## Para testes, voltar ao título.
@export var next_scene : PackedScene

var is_drink_delivered : bool = false

@onready var brewing_interface = %BrewingInterface
@onready var recipe_list = %RecipeList

func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal_event)
	Dialogic.timeline_ended.connect(_on_dialogic_timeline_ended)
	brewing_interface.drink_delivered.connect(_on_drink_delivered)
	brewing_interface.interface_hidden.connect(recipe_list.hide_interface)

	MusicPlayer.set_current($Music)
	_start_events()


## TODO
func play_character_animation(char_name : String, animation_name : String) -> void:
	var character = $Characters.get_node_or_null(char_name)
	if not character:
		print_debug("WARN: Couldn't find character: %s" % char_name)
		return

	var anim_player : AnimationPlayer = character.get_node("AnimationPlayer")
	anim_player.play(animation_name)


## TODO
func change_camera(camera_index : int) -> void:
	if $Cameras.get_child_count() <= camera_index: # não possui a camera tal
		print_debug("WARN: Invalid camera index: %d" % camera_index)
		return
	var picked_camera : Camera3D = $Cameras.get_child(camera_index)

	picked_camera.make_current()



func _on_dialogic_signal_event(argument : String) -> void:
	match argument:
		"brewing":
			brewing_interface.show_interface()
			recipe_list.show_interface()


func _on_dialogic_timeline_ended() -> void:
	print_debug("fim da timeline")
	## TODO: alguns eventos podem não requerir drinks (motivos de plot)
	## Decidir uma forma de tratar esses eventos (por exemplo, ligar a flag pelo dialogic)
	# se não houve entrega de drink,
	if is_drink_delivered:
		#do_next_event
		print_debug("indo pra próxima")
		_finish_scene()


func _on_drink_delivered(drink : DrinkRecipe) -> void:
	barista_event.receive_drink(drink)
	is_drink_delivered = true
	#brewing_interface.hide_interface()


func _input(input_event):
	if input_event is InputEventKey:
		var key_event = input_event as InputEventKey
		_debug_key_input(key_event)



func _start_events() -> void:
	# mudar pra fazer um loop pra rodar todos os eventos
	is_drink_delivered = false
	barista_event.open_start_dialogue()


func _finish_scene() -> void:
	Loader.load_scene_from_packed(next_scene)


func _debug_key_input(key_event : InputEventKey):
	if not key_event.pressed: return
	if key_event.echo: return

	if key_event.keycode == KEY_F:
		barista_event._debug_receive_drink(false)
		is_drink_delivered = true
	elif key_event.keycode == KEY_G:
		barista_event._debug_receive_drink(true)
		is_drink_delivered = true

