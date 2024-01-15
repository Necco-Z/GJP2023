extends Control

enum Mode {SAVE, LOAD}

var current_drink: DrinkRecipe
var current_mode := Mode.SAVE

@onready var drink_name := %DrinkName as LineEdit
@onready var drink_image := %DrinkImage as TextureRect
@onready var base_ingredient := %BaseIngredient as OptionButton
@onready var extra_ingredient_1 := %ExtraIngredient1 as OptionButton
@onready var extra_ingredient_2 := %ExtraIngredient2 as OptionButton
@onready var aspect_details := %AspectDetails as Label
@onready var file_dialog := $FileDialog as FileDialog
@onready var status_message := $StatusMessage as Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_drink = DrinkRecipe.new()
	for i in GlobalResources.ingredients_list:
		if i.is_base:
			base_ingredient.add_item(i.name)
			if i.is_milk:
				extra_ingredient_1.add_item(i.name)
				extra_ingredient_2.add_item(i.name)
		else:
			extra_ingredient_1.add_item(i.name)
			extra_ingredient_2.add_item(i.name)
	_clear_fields()


func _clear_fields() -> void:
	for i in get_tree().get_nodes_in_group("tool_field"):
		if i is LineEdit:
			i.text = ""
		elif i is TextureRect:
			i.texture = null
		elif i is Label:
			i.text = ""
		else:
			i.selected = -1


func _set_status(msg: String) -> void:
	status_message.text = msg
	await get_tree().create_timer(4.0).timeout
	status_message.text = ""


func _load_recipe(recipe: DrinkRecipe) -> void:
	drink_name.text = recipe.name
	#drink_image.texture = recipe.image
	for i in base_ingredient.item_count:
		if base_ingredient.get_item_text(i) == recipe.base.name:
			base_ingredient.select(i)
			break
	if recipe.additives[0] != null:
		var additive = recipe.additives[0]
		for i in extra_ingredient_1.item_count:
			if extra_ingredient_1.get_item_text(i) == additive.name:
				extra_ingredient_1.select(i)
				extra_ingredient_2.disabled = false
				break
	if recipe.additives[1] != null:
		var additive = recipe.additives[1]
		for i in extra_ingredient_2.item_count:
			if extra_ingredient_2.get_item_text(i) == additive.name:
				extra_ingredient_2.select(i)
				break
	_load_aspects()
	_set_status("Receita carregada.")


func _load_aspects() -> void:
	var t = ""
	var aspects = current_drink.get_aspects()
	for a in aspects:
		t += a + ": " + str(aspects[a]) + "\n"
	t = t.trim_suffix("\n")
	aspect_details.text = t


## Retorna uma string vazia se não houver erros
func _check_drink_validity() -> String:
	var t = ""
	if drink_name.text == "":
		t = "Nenhum nome dado à bebida"
	if base_ingredient.selected < 0:
		t = "Bebida sem ingrediente base"
	if extra_ingredient_1.selected < 1 or extra_ingredient_2.selected < 1:
		t = "Bebida precisa ter dois ingredientes adicionais"
	if t != "":
		t += " - não foi possível salvar."
	return t


## Signals
func _on_new_pressed() -> void:
	_clear_fields()


func _on_load_pressed() -> void:
	current_mode = Mode.LOAD
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	file_dialog.popup_centered_ratio()


func _on_save_pressed() -> void:
	var t = _check_drink_validity()
	if t != "":
		_set_status(t)
		return
	current_mode = Mode.SAVE
	file_dialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	file_dialog.current_file = drink_name.text.to_snake_case() + ".tres"
	file_dialog.popup_centered_ratio()


func _on_file_selected(path: String) -> void:
	if current_mode == Mode.LOAD:
		var d = load(path) as DrinkRecipe
		if d != null:
			current_drink = d
			_load_recipe(d)
	elif current_mode == Mode.SAVE:
		ResourceSaver.save(current_drink, path)
		_set_status("Receita salva.")


func _on_drink_name_text_changed(new_text: String) -> void:
	current_drink.name = new_text


func _on_base_ingredient_item_selected(index: int) -> void:
	var selected = base_ingredient.get_item_text(index)
	for i in GlobalResources.ingredients_list:
		if i.name == selected:
			current_drink.base = i
			break
	_load_aspects()


func _on_extra_ingredient_1_item_selected(index: int) -> void:
	if index < 1:
		extra_ingredient_2.select(-1)
		extra_ingredient_2.disabled = true
		current_drink.additives.resize(0)
	else:
		extra_ingredient_2.disabled = false
		var selected = extra_ingredient_1.get_item_text(index)
		for i in GlobalResources.ingredients_list:
			if i.name == selected:
				current_drink.additives[0] = i
				break
	_load_aspects()


func _on_extra_ingredient_2_item_selected(index: int) -> void:
	if index < 1:
		current_drink.additives[0] = null
	else:
		var selected = extra_ingredient_2.get_item_text(index)
		for i in GlobalResources.ingredients_list:
			if i.name == selected:
				current_drink.additives[1] = i
				break
	_load_aspects()
