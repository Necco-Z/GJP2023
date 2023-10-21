extends Node

var recipes := {
	"Latte": ["Coffee", "Milk", "Milk"],
	"Espresso": ["Coffee", "Coffee", "Coffee"],
}


func _ready() -> void:
	for i in recipes:
		recipes[i].sort()


func compare_recipes(list: Array) -> String:
	list.sort()
	var result = ""
	for i in recipes:
		if list == recipes[i]:
			result = i
			break
	return result
