extends Control

@export var anim_time := 0.5

var open_pos := 1508
var closed_pos := 1930
var tween_time := 0.5
var is_open := false
var current_recipe := 0:
	set = _set_current_recipe

@onready var bg = $BG as TextureRect
@onready var recipe_name = $BG/Name as Label
@onready var base = $BG/Base as Label
@onready var add1 = $BG/Additive1 as Label
@onready var add2 = $BG/Additive2 as Label
@onready var call_list = $CallList as TextureButton


func _ready() -> void:
	bg.position.x = closed_pos
	_set_current_recipe(current_recipe)
	anchor_top = -1
	anchor_bottom = 0


# public
func show_interface() -> void:
	print("mostrando interface")
	var t = create_tween()
	t = t.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	t.tween_property(self, "anchor_top", 0, tween_time)
	t.tween_property(self, "anchor_bottom", 1, tween_time)


func hide_interface() -> void:
	var t = create_tween()
	t = t.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC).set_parallel()
	t.tween_property(self, "anchor_top", -1, tween_time)
	t.tween_property(self, "anchor_bottom", 0, tween_time)


func _set_current_recipe(value: int) -> void:
	current_recipe = clamp(value, 0, GlobalResources.recipes_list.size() - 1)
	var recipe : DrinkRecipe = GlobalResources.recipes_list[value]
	recipe_name.text = recipe.name
	base.text = recipe.base.name
	add1.text = recipe.additives[0].name
	add2.text = recipe.additives[1].name


func _on_call_list_pressed() -> void:
	var t = create_tween().set_parallel().set_trans(Tween.TRANS_SINE)
	if is_open:
		t.tween_property(call_list, "rotation", 0, anim_time).set_trans(Tween.TRANS_LINEAR)
		t.tween_property(bg, "position:x", closed_pos, anim_time).set_ease(Tween.EASE_IN)
		is_open = false
	else:
		t.tween_property(call_list, "rotation", PI, anim_time).set_trans(Tween.TRANS_LINEAR)
		t.tween_property(bg, "position:x", open_pos, anim_time).set_ease(Tween.EASE_OUT)
		is_open = true


func _on_prev_pressed() -> void:
	current_recipe = int(fposmod(current_recipe - 1, GlobalResources.recipes_list.size()))


func _on_next_pressed() -> void:
	current_recipe = int(fposmod(current_recipe + 1, GlobalResources.recipes_list.size()))
