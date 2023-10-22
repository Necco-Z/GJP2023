extends Control

signal interface_hidden
signal drink_delivered

@export var start_hidden := false

var custom_recipe : Recipe
var tween_time := 0.5

@onready var list := $List as Label
@onready var notification := $Notification as Label
@onready var ingredient_list := $Ingredients as Control


# built-in
func _ready() -> void:
	if start_hidden:
		anchor_top = -1
		anchor_bottom = 0
	for i in ingredient_list.get_children():
		i.connect("pressed", _on_ingredient_chosen.bind(i.text))
	$FinishButtons/StartOver.connect("pressed", _on_start_over)
	$FinishButtons/Deliver.connect("pressed", _on_deliver)


# public
func show_interface() -> void:
	var t = create_tween()
	t = t.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	t.tween_property(self, "anchor_top", 0, tween_time)
	t.tween_property(self, "anchor_bottom", 1, tween_time)


func hide_interface() -> void:
	var t = create_tween()
	t = t.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC).set_parallel()
	t.tween_property(self, "anchor_top", -1, tween_time)
	t.tween_property(self, "anchor_bottom", 0, tween_time)
	await t.finished
	interface_hidden.emit()

# private
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


# signals
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
	custom_recipe = null
	_update_drink()
	await hide_interface()
	drink_delivered.emit()
