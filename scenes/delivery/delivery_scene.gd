extends Control

@export var deli_amount_max = 2
var deli_amount = 0
var selected_location : DeliveryLocation = null

enum DeliveryType { NONE=0, INTEL=1, PLACE=2, PEOPLE=3}

@export_multiline var desc_none_delivery : String = "Não fazer entregas nesse local."
@export_multiline var desc_intel_delivery : String = "Pegar Informação"
@export_multiline var desc_place_delivery : String = "Afetar Mundo"
@export_multiline var desc_people_delivery : String = "Afetar Personagem"

var button_to_location : Dictionary = {
	#BtnNode: #"locationResource"
}

var choices : Dictionary = {
	#"_locationName": DeliveryType.INTEL
}


# Called when the node enters the scene tree for the first time.
func _ready():
	%DeliveryTypeSelect.visible = false
	update_selected_count()
	_setup_locations_list()
	_setup_types_list()
	await get_tree().create_timer(0.5).timeout
	%LocationSelect.get_child(0).grab_focus()
	pass # Replace with function body.



func connect_location_button_signals(btn:Button):
	btn.mouse_entered.connect(_on_location_button_mouse_entered.bind(btn))
	btn.focus_entered.connect(_on_location_button_focus_entered.bind(btn))
	btn.pressed.connect(_on_location_button_pressed.bind(btn))


func update_selected_count():
	deli_amount = choices.size()
	%SelectedCountText.text = "Selected: %d/%d" %[deli_amount, deli_amount_max]


func advance_to_type_select(location_btn:Button):
	selected_location = button_to_location[location_btn]
	%DeliveryTypeSelect.visible = true
	%DeliveryTypeSelect.global_position.y = location_btn.global_position.y
	
	var selected_type = choices.get(selected_location, 0)
	
	for child in %DeliveryTypeSelect.get_children(): 
		child.disabled = false
		child.button_pressed = false
		if selected_type == DeliveryType.NONE and deli_amount >= deli_amount_max:
			child.disabled = true
	var selected_btn = %DeliveryTypeSelect.get_child(selected_type)
	selected_btn.button_pressed = true
	selected_btn.grab_focus()



func return_from_type_select():
	var btn = button_to_location.find_key(selected_location)
	btn.button_pressed = false
	selected_location = null
	btn.grab_focus()
	%DeliveryTypeSelect.visible = false


func _setup_locations_list() -> void:
	for child in %LocationSelect.get_children(): child.queue_free()
	for location : DeliveryLocation in GlobalResources.deli_locations_list:
		var btn = Button.new()
		btn.name = "Btn" + location.name
		btn.text = location.name
		btn.toggle_mode = true
		button_to_location[btn] = location
		%LocationSelect.add_child(btn)
		connect_location_button_signals(btn)
	
	var confirmBtn = Button.new()
	confirmBtn.name = "BtnConfirm"
	confirmBtn.text = "Confirmar"
	%LocationSelect.add_child(confirmBtn)
	connect_location_button_signals(confirmBtn)


func _setup_types_list() -> void:
	for index in range(4):
		var btn = %DeliveryTypeSelect.get_child(index)
		btn.mouse_entered.connect(_on_type_button_mouse_entered.bind(index))
		btn.focus_entered.connect(_on_type_button_focus_entered.bind(index))
		btn.pressed.connect(_on_type_button_pressed.bind(index))


func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		if selected_location != null:
			return_from_type_select()


## Signals


func _on_location_button_mouse_entered(btn:Button):
	if selected_location != null: return
	btn.grab_focus()

func _on_location_button_focus_entered(btn:Button):
	# if image, show related image here.
	if btn.name == "BtnConfirm":
		%DescriptionTextBox.text = "Enviar as entregas conforme escolhido."
	else:
		if selected_location != null: return
		%DescriptionTextBox.text = button_to_location[btn].description

func _on_location_button_pressed(btn:Button):
	for child in %LocationSelect.get_children(): 
		child.button_pressed = false
	if btn.name == "BtnConfirm":
		#confirm_deliveries()
		return
	#else:
	btn.button_pressed = true
	advance_to_type_select(btn)


func _on_type_button_mouse_entered(index:int):
	%DeliveryTypeSelect.get_child(index).grab_focus()

func _on_type_button_focus_entered(index:int):
	match index:
		DeliveryType.NONE:
			%DescriptionTextBox.text = desc_none_delivery
		DeliveryType.INTEL:
			%DescriptionTextBox.text = desc_intel_delivery
		DeliveryType.PLACE:
			%DescriptionTextBox.text = desc_place_delivery
		DeliveryType.PEOPLE:
			%DescriptionTextBox.text = desc_people_delivery

func _on_type_button_pressed(index:int):
	for child in %DeliveryTypeSelect.get_children(): 
		child.button_pressed = false
	var btn = %DeliveryTypeSelect.get_child(index)
	btn.button_pressed = true
	if index == DeliveryType.NONE:
		choices.erase(selected_location)
	else:
		choices[selected_location] = index
	update_selected_count()
