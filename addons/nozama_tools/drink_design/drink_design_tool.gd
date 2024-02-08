@tool
extends Control

enum Mode {SAVE, LOAD}

var current_drink: DrinkRecipe
var current_mode := Mode.SAVE
var aspects := ["sweet", "bitter", "smooth", "warm", "fresh"]
var status_tween : Tween

var drink_name : LineEdit
var drink_image : TextureRect
var base_ingredient : OptionButton
var extra_ingredient_1 : OptionButton
var extra_ingredient_2 : OptionButton
var aspect_details : Label
var file_dialog : EditorFileDialog
var status_message : Label
var ingredient_list : Array[Ingredient]


func _enter_tree() -> void:
	_load_child_nodes()
	current_drink = DrinkRecipe.new()
	ingredient_list = _load_ingredients()
	base_ingredient.clear()
	extra_ingredient_1.clear()
	extra_ingredient_2.clear()
	for i in ingredient_list:
		if i.is_base:
			base_ingredient.add_item(i.name)
			if i.can_be_additive:
				extra_ingredient_1.add_item(i.name)
				extra_ingredient_2.add_item(i.name)
		else:
			extra_ingredient_1.add_item(i.name)
			extra_ingredient_2.add_item(i.name)


func _ready() -> void:
	_clear_fields()


func _load_child_nodes() -> void:
	drink_name = %DrinkName
	drink_image = %DrinkImage
	base_ingredient = %BaseIngredient
	extra_ingredient_1 = %ExtraIngredient1
	extra_ingredient_2 = %ExtraIngredient2
	aspect_details = %AspectDetails
	file_dialog = _create_editor_dialog()
	status_message = $StatusMessage


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
	extra_ingredient_2.disabled = true


func _load_ingredients() -> Array[Ingredient]:
	var ingredient_list: Array[Ingredient]
	var paths = _get_all_file_paths("res://data/brewing_system/ingredients")
	for path in paths:
		var ingredient := ResourceLoader.load(path) as Ingredient
		ingredient_list.append(ingredient)
	return ingredient_list


func _create_editor_dialog() -> EditorFileDialog:
	var dialog := EditorFileDialog.new()
	dialog.current_path = "res://data/brewing_system/recipes/"
	dialog.file_selected.connect(_on_file_selected)
	add_child(dialog)
	return dialog


func _set_status(msg: String) -> void:
	status_message.text = msg
	if status_tween != null:
		status_tween.kill()
	status_tween = create_tween()
	status_tween.tween_property(status_message, "modulate", Color.WHITE, 0.1)
	status_tween.tween_interval(3.0)
	status_tween.tween_property(status_message, "modulate", Color.TRANSPARENT, 0.1)
	status_message.text = msg


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
	if current_drink.base == null:
		return
	var t = ""
	var drink_aspects = current_drink.get_aspects()
	for a in drink_aspects:
		t += aspects[a] + ": " + str(drink_aspects[a]) + "\n"
	t = t.trim_suffix("\n")
	aspect_details.text = t


## Retorna uma string vazia se não houver erros
func _check_drink_validity() -> String:
	var t = ""
	if drink_name.text == "":
		t = "Nenhum nome dado à bebida"
	elif base_ingredient.selected < 0:
		t = "Bebida sem ingrediente base"
	elif extra_ingredient_1.selected < 0 or extra_ingredient_2.selected < 0:
		t = "Bebida precisa ter dois ingredientes adicionais"
	if t != "":
		t += " - não foi possível salvar."
	return t


func _get_all_file_paths(path: String) -> Array[String]:
	var file_paths: Array[String] = []
	var dir = DirAccess.open(path)
	if dir == null:
		push_error("Path \"", path, "\" doesn't exist.")
		return []
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		var file_path = path + "/" + file_name # global path separator, includes Windows
		file_paths.append(file_path)
		file_name = dir.get_next()
	return file_paths


## Signals
func _on_new_pressed() -> void:
	current_drink = DrinkRecipe.new()
	_clear_fields()


func _on_load_pressed() -> void:
	current_mode = Mode.LOAD
	file_dialog.file_mode = EditorFileDialog.FILE_MODE_OPEN_FILE
	file_dialog.popup_centered_ratio()


func _on_save_pressed() -> void:
	var t = _check_drink_validity()
	if t != "":
		_set_status(t)
		return
	current_mode = Mode.SAVE
	file_dialog.file_mode = EditorFileDialog.FILE_MODE_SAVE_FILE
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
	for i in ingredient_list:
		if i.name == selected:
			current_drink.base = i
			break
	_load_aspects()


func _on_extra_ingredient_1_item_selected(index: int) -> void:
	if index < 0:
		extra_ingredient_2.select(-1)
		extra_ingredient_2.disabled = true
		current_drink.additives[0] = null
	else:
		extra_ingredient_2.disabled = false
		var selected = extra_ingredient_1.get_item_text(index)
		for i in ingredient_list:
			if i.name == selected:
				current_drink.additives[0] = i
				break
	_load_aspects()


func _on_extra_ingredient_2_item_selected(index: int) -> void:
	if index < 0:
		current_drink.additives[1] = null
	else:
		var selected = extra_ingredient_2.get_item_text(index)
		for i in ingredient_list:
			if i.name == selected:
				current_drink.additives[1] = i
				break
	_load_aspects()
