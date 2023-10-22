extends Control

var custom_recipe : Recipe

@onready var list := $List as Label
@onready var notification := $Notification as Label
@onready var ingredient_list := $Ingredients as Control


func _ready() -> void:
	for i in ingredient_list.get_children():
		i.connect("pressed", _on_ingredient_chosen.bind(i.text))
	$FinishButtons/StartOver.connect("pressed", _on_start_over)
	$FinishButtons/Deliver.connect("pressed", _on_deliver)


func _update_drink() -> void:
	if custom_recipe == null:
		list.text = ""
		return

	var ingredients = custom_recipe.list_ingredients()
	var result = ""
	for i in range(ingredients.size()):
		if i == ingredients.size() - 1:
			result += ingredients[i]
		else:
			result += ingredients[i] + "\n"
	list.text = result


func _show_result(msg: String) -> void:
	notification.text = msg
	await get_tree().create_timer(3).timeout
	notification.text = ""


func _on_ingredient_chosen(ingredient := "") -> void:
	if ingredient == "":
		return

	if custom_recipe == null:
		custom_recipe = Recipe.new([ingredient])
	else:
		custom_recipe.add_ingredient(ingredient)
	_update_drink()


func _on_start_over() -> void:
	custom_recipe = null
	_update_drink()


func _on_deliver() -> void:
	if custom_recipe == null:
		return
	var result = Data.compare_recipes(custom_recipe)
	Dialogic.VAR.current_drink = result
	if result == "":
		_show_result("Wrong recipe")
	else:
		_show_result(result)
	custom_recipe = null
	_update_drink()
