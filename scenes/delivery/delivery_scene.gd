extends Control

enum DeliveryType { NONE=0, INTEL=1, WORLD=2, PEOPLE=3}

var button_to_location : Dictionary = {
	#BtnNode: #"locationResource"
}

var choices : Dictionary = {
	#"_locationName": DeliveryType.INTEL
}

@export var deli_amount_max = 2

var deli_amount = 0
var current_location_button : Button = null

# Called when the node enters the scene tree for the first time.
func _ready():
	_setup_locations_list()
	await get_tree().create_timer(0.5).timeout
	%LocationSelect.get_child(0).grab_focus()
	pass # Replace with function body.


func _setup_locations_list() -> void:
	for child in %LocationSelect.get_children(): child.queue_free()
	for location : DeliveryLocation in GlobalResources.deli_locations_list:
		var btn = Button.new()
		btn.name = "Btn" + location.name
		btn.text = location.name
		button_to_location[btn] = location
		%LocationSelect.add_child(btn)
		connect_location_button_signals(btn)
	
	var confirmBtn = Button.new()
	confirmBtn.name = "BtnConfirm"
	confirmBtn.text = "Confirmar"
	%LocationSelect.add_child(confirmBtn)
	connect_location_button_signals(confirmBtn)



#TODO: connect confirm signals here
func connect_location_button_signals(btn:Button):
	btn.mouse_entered.connect(_on_button_mouse_entered.bind(btn))
	btn.focus_entered.connect(_on_location_button_focus_entered.bind(btn))


## Signals

func _on_button_mouse_entered(btn:Button):
	btn.grab_focus()

func _on_location_button_focus_entered(btn:Button):
	if btn.name == "BtnConfirm":
		%DescriptionTextBox.text = "Enviar as entregas conforme escolhido."
	else:
		%DescriptionTextBox.text = button_to_location[btn].description

