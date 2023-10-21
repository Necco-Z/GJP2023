class_name Recipe
extends Resource

@export var name : String
@export var main_item : String
@export var secondary_items : Array[String]


func _init(ingredients := []) -> void:
	if ingredients.size() > 3:
		ingredients.resize(3)
	main_item = ingredients.pop_front()
	secondary_items.append_array(ingredients)


func compare_to(other: Recipe) -> bool:
	var result = false
	if main_item == other.main_item:
		secondary_items.sort()
		other.secondary_items.sort()
		if secondary_items == other.secondary_items:
			result = true
	return result


func list_ingredients() -> Array[String]:
	var result := [main_item] as Array[String]
	result.append_array(secondary_items)
	return result


func add_ingredient(ingredient: String) -> void:
	if ingredient == "":
		return

	if main_item == "":
		main_item = ingredient
	elif secondary_items.size() < 2:
		secondary_items.append(ingredient)
	else:
		print("too many ingredients")
