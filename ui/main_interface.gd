extends Control

var chosen_ingredients := []

@onready var list := $List as Label
@onready var notification := $Notification as Label
@onready var ingredient_list := $ScrollContainer/Ingredients as VBoxContainer


func _ready() -> void:
	for i in ingredient_list.get_children():
		i.connect("pressed", _on_ingredient_chosen.bind(i.name))
	$FinishButtons/StartOver.connect("pressed", _on_start_over)
	$FinishButtons/Deliver.connect("pressed", _on_deliver)


func _update_drink() -> void:
	var result = ""
	for i in range(chosen_ingredients.size()):
		if i == chosen_ingredients.size() - 1:
			result += chosen_ingredients[i]
		else:
			result += chosen_ingredients[i] + "\n"
	list.text = result


func _show_result(msg: String) -> void:
	notification.text = msg
	await get_tree().create_timer(3).timeout
	notification.text = ""


func _on_ingredient_chosen(ingredient := "") -> void:
	if ingredient != "":
		if list.text == "":
			list.text = ingredient
		else:
			list.text += "\n" + ingredient
		chosen_ingredients.append(ingredient)


func _on_start_over() -> void:
	chosen_ingredients.clear()
	_update_drink()


func _on_deliver() -> void:
	var result = Data.compare_recipes(chosen_ingredients)
	if result == "":
		_show_result("Wrong recipe")
	else:
		_show_result(result)
