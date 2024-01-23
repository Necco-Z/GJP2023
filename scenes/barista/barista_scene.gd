class_name BaristaScene
extends Node3D


## No futuro, carregar eventos proceduralmente de uma pasta dependendo do dia.
## Também fazer um vetor de eventos.
@export var event : BaristaEvent



@export var brewing_interface : Control


func _ready():
	brewing_interface.connect("drink_delivered", _on_drink_delivered)
	MusicPlayer.set_current($Music)
	start_events()


func start_events() -> void:
	# mudar pra fazer um loop pra rodar todos os eventos
	event.open_start_dialogue()


func show_brewing_interface():
	brewing_interface.show_interface()
func hide_brewing_interface():
	brewing_interface.hide_interface()


func play_character_animation(char_index : int, animation_name : String) -> void:
	pass


func _on_drink_delivered(drink : DrinkRecipe) -> void:
	event.receive_drink(drink)
