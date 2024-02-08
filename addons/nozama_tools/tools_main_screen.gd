@tool
extends ColorRect


func _enter_tree() -> void:
	color = get_theme_color("dark_color_1", "Editor")
	var tab_container := %TabContainer as TabContainer
	for i in tab_container.get_children():
		var index := tab_container.get_tab_idx_from_control(i)
		var tab_name := i.name.capitalize()
		tab_container.set_tab_title(index, tab_name)
