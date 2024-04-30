class_name DrinkRequest
extends Resource
## Superclasse, define condições que uma bebida deve ter para que
## uma fala escondida seja revelada por um Cliente/NPC.
## Estes objetos não são salvos no banco de dados, mas sim dentro de cada EventoDiurno.

signal drink_received_correct
signal drink_received_wrong

## virtual
func _init() -> void:
	#drink_received_correct.connect(PlayerData._on_correct_recipe)
	#drink_received_wrong.connect(PlayerData._on_wrong_recipe)
	pass


func try_fulfill_request(_drink_to_test : DrinkRecipe) -> bool:
	return false
