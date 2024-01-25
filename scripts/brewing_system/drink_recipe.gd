class_name DrinkRecipe
extends Resource

var name : String
## Textura com a imagem do drink quando pronto. Pode ser usado na UI e no diário.
var texture : Texture2D
## O ingrediente líquido base da bebida.
var base : Ingredient
## Os ingredientes adicionais fora a base da bebida.
@export var additives : Array[Ingredient] = [null, null]


func add_ingredient(ingr: Ingredient) -> void:
	if base == null:
		if not ingr.is_base:
			printerr("Ingrediente inicial não é base")
		else:
			base = ingr
	elif additives[0] == null or additives[1] == null:
		if ingr.is_base and not ingr.can_be_additive:
			printerr("Ingrediente não pode ser aditivo")
		if additives[0] == null:
			additives[0] = ingr
		else:
			additives[1] = ingr


func list_ingredients() -> Array[Ingredient]:
	var a : Array[Ingredient] = []
	a.append(base)
	a.append_array(additives)
	a.erase(null)
	return a


## Retorna um Dictionary com os aspectos separados por nome.
func get_aspects() -> Dictionary:
	# sweet, bitter, smooth, warm, fresh
	var flavor_array := [0,0,0,0,0]

	# aspects vão de 0 a 4, perfeito
	for i in range(5):
		flavor_array[i] = base.aspects_dict[i]
		if additives[0] != null:
			flavor_array[i] += additives[0].aspects_dict[i]
		if additives[1] != null:
			flavor_array[i] += additives[1].aspects_dict[i]

	var flavor_dict = {
			0: flavor_array[0],
			1: flavor_array[1],
			2: flavor_array[2],
			3: flavor_array[3],
			4: flavor_array[4]
	}
	return flavor_dict


## Retorna [code]true[/code] se tiverem os mesmos ingredientes.
func compare_with(other_recipe : DrinkRecipe) -> bool:
	if base != other_recipe.base:
		return false
	# comparar se dois vetores de mesmo tamanho tem os mesmos itens
	for item in additives:
		if additives.count(item) != other_recipe.additives.count(item):
			return false
	return true


func _to_string() -> String:
	var t := "%s: [%s" % [name, base.name]
	for i in additives:
		if i != null:
			t += ", %s" % i.name
	t += "]"
	return t

