class_name DrinkRequest
extends Resource
## Superclasse, define condições que uma bebida deve ter para que 
## uma fala escondida seja revelada por um Cliente/NPC. 
## Estes objetos não são salvos no banco de dados, mas sim dentro de cada EventoDiurno.


## virtual
func try_fulfill_request(drink_to_test : DrinkRecipe) -> bool:
	return false
