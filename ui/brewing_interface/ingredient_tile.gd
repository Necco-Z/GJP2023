@tool
extends Container

@export_range(0, 20, 1, "or_greater", "suffix:px") var icon_margin := 5:
	set = _set_icon_margin

var ingredient: Ingredient:
	set = _set_ingredient


func _notification(what: int) -> void:
	if what == NOTIFICATION_SORT_CHILDREN:
		fit_child_in_rect($ColorRect, Rect2(Vector2(), size))
		fit_child_in_rect($Label, Rect2(Vector2(), size))
		_set_image_size()


# Setters e getters
func _set_ingredient(value: Ingredient) -> void:
	ingredient = value
	if value != null:
		if value.icon == null:
			$Label.text = value.name
			$Icon.texture = null
		else:
			$Label.text = ""
			$Icon.texture = value.icon
	else:
		$Label.text = ""
		$Icon.texture = null
	queue_sort()


func _set_icon_margin(value: int) -> void:
	value = max(0, value)
	icon_margin = value
	queue_sort()


func _set_image_size() -> void:
	if not $Icon.texture:
		return
	var image_rect := Rect2()
	var texture_size = $Icon.texture.get_size()
	var proportions = (size - Vector2(icon_margin * 2, icon_margin * 2)) / texture_size
	var scale_factor = min(proportions.x, proportions.y)
	image_rect.size = texture_size * scale_factor
	image_rect.position.y = size.y - image_rect.size.y - icon_margin
	image_rect.position.x = (size.x - image_rect.size.x) / 2
	fit_child_in_rect($Icon, image_rect)
