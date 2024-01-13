class_name AspectDrinkRequest
extends DrinkRequest


## ABOVE_THRESHOLD é maior ou igual. BELOW_THRESHOLD é menor ou igual.
enum CompareMode { ABOVE_THRESHOLD, BELOW_THRESHOLD }

@export var conditions : Array = []

func try_fulfill_request(drink_to_test : DrinkRecipe) -> bool:
	var aspects_dict := drink_to_test.get_aspects()
	
	for condition in conditions:
		var passed := true
		var aspect_to_compare = aspects_dict[condition.aspect]
		
		match condition.mode:
			CompareMode.ABOVE_THRESHOLD:
				passed = aspect_to_compare >= condition.threshold
			CompareMode.BELOW_THRESHOLD:
				passed = aspect_to_compare <= condition.threshold
		
		if not passed: return false
	
	return true


class AspectCondition:
	var aspect : Ingredient.Aspects = Ingredient.Aspects.SWEET
	var mode : CompareMode = CompareMode.ABOVE_THRESHOLD
	var threshold : int = 0
