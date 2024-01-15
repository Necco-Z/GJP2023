class_name AspectDrinkRequest
extends DrinkRequest


enum AspectType { SWEET, BITTER, SMOOTH, WARM, FRESH }
@export var aspect : AspectType = AspectType.SWEET

enum CompareMode { MORE_THAN, MORE_OR_EQUAL, EQUAL, LESS_OR_EQUAL, LESS }
@export var compare_mode : CompareMode = CompareMode.MORE_OR_EQUAL

@export var target_value : int = 0


func try_fulfill_request(drink_to_test : DrinkRecipe) -> bool:
	var value_to_compare := 0
	var aspects := drink_to_test.get_aspects()
	
	match aspect:
		AspectType.SWEET:
			value_to_compare = aspects["sweet"]
		AspectType.BITTER:
			value_to_compare = aspects["bitter"]
		AspectType.SMOOTH:
			value_to_compare = aspects["smooth"]
		AspectType.WARM:
			value_to_compare = aspects["warm"]
		AspectType.FRESH:
			value_to_compare = aspects["fresh"]
	
	match compare_mode:
		CompareMode.MORE_THAN:
			return value_to_compare > target_value
		CompareMode.MORE_OR_EQUAL:
			return value_to_compare >= target_value
		CompareMode.EQUAL:
			return value_to_compare == target_value
		CompareMode.LESS_OR_EQUAL:
			return value_to_compare <= target_value
		CompareMode.LESS:
			return value_to_compare < target_value
	
	return false