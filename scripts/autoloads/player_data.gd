extends Node

var save_path = "user://player_stats.csv"

var data = {
	"player_id" : "",
	"ingredient_clicks" : 0,
	"wrong_recipes" : 0,
	"correct_recipes" : 0,
	"list_opened" : 0,
	"interface_reset" : 0,
}


func reset_data() -> void:
	data.player_id = Time.get_datetime_string_from_system()
	data.ingredient_clicks = 0
	data.wrong_recipes = 0
	data.correct_recipes = 0
	data.list_opened = 0
	data.interface_reset = 0


func save_data() -> void:
	var first_time = false if FileAccess.file_exists(save_path) else true
	var file := FileAccess.open(save_path, FileAccess.WRITE)
	if first_time:
		file.store_csv_line(data.keys())
	var save_array : PackedStringArray = []
	for i in data.keys():
		save_array.append(str(data[i]))
	file.store_csv_line(save_array)


func _on_ingredient_clicked() -> void:
	data.ingredient_clicks += 1


func _on_correct_recipe() -> void:
	data.correct_recipes += 1


func _on_list_opened() -> void:
	data.list_opened += 1


func _on_wrong_recipe() -> void:
	data.wrong_recipes += 1


func _on_interface_reset() -> void:
	data.interface_reset += 1

