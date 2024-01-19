extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$BtnReturn.grab_focus()



func _on_btn_return_pressed():
	#save_configs()
	Loader.load_scene("res://ui/main_menu.tscn")


func save_configs():
	pass
