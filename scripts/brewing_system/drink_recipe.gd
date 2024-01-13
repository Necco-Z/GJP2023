class_name DrinkRecipe
extends Resource

## Os diferentes tipos de erros que uma receita pode ter.
## [code]NULL_BASE[/code]: ingrediente base está vazio.
## [code]BASE_IS_NOT_BASE[/code]: ingrediente que deve ser base tem valor `ìs_base` como falso.
## [code]USING_BASE_AS_ADDITIVE[/code]: uma base diferente da base atual foi inclusa nos aditivos (Leite é uma exceção).
## [code]INCORRECT_AMOUNT_OF_ADDITIVES[/code]: foram incluídos mais ou menos aditivos que a quantidade correta: dois.
enum Errors { NULL_BASE, BASE_IS_NOT_BASE, USING_BASE_AS_ADDITIVE, INCORRECT_AMOUNT_OF_ADDITIVES }
## Semelhante a uma bit-field, esse Dictionary terá uma chave para cada erro detectado.
## Usa os valores do enum Erros como chaves e `true` como o valor de cada chave existente.
var errors = {}

@export var name : String = ""

@export_category("Ingredients")

## O ingrediente líquido base da bebida.
@export var base : Ingredient:
	set(ingredient):
		if not _validate_base(ingredient):
			push_error("Base ingredient in recipe \"%s\" must have `is_base` set to true." % name)
		base = ingredient

## Os ingredientes adicionais fora a base da bebida.
## Não é possível incluir ingredientes base, a não ser que sejam o mesmo
## da base da bebida, ou ingredientes como o Leite.
## A ordem não importa.
@export var additives : Array[Ingredient] = [null, null]:
	set(array):
		if not _validate_additives(array):
			push_error("Error when choosing additives for \"%s\"." % name)
			# TODO: detectar os erros em específico.
		array.resize(2)
		additives = array

## Cria uma receita genérica durante o jogo a partir desses ingredientes.
## Retorna bool pois pode falhar (validação de erro).
## Os erros podem ser obtidos posteriormente com DrinkRecipe.errors
## Certifique-se que a base é passada como elemento de índice 0 do vetor no código.
func make(ingredients : Array[Ingredient]) -> bool:
	
	var base_candidate = ingredients.pop_front() # remove a base, sobram aditivos
	if not _validate_base(base_candidate):
		return false
	base = base_candidate
	
	if not _validate_additives(ingredients):
		return false
	additives = ingredients.duplicate() # ingredients pertence à uma função superior, precisa clonar
	
	return true


## Retorna um Dictionary com os aspectos separados por nome.
func get_aspects() -> Dictionary:
	# sweet, bitter, smooth, warm, fresh
	var flavor_array := [0,0,0,0,0]
	
	# aspects vão de 0 a 4, perfeito
	for i in range(5):
		flavor_array[i] = base.aspects_dict[i]
		flavor_array[i] += additives[0].aspects_dict[i]
		flavor_array[i] += additives[1].aspects_dict[i]
	
	var flavor_dict = {
			0: flavor_array[0],
			1: flavor_array[1],
			2: flavor_array[2],
			3: flavor_array[3],
			4: flavor_array[4]
	}
	return flavor_dict


## Retorna [code]true[/code] se tiverem os mesmos ingredientes.
func compare_with(other_recipe : DrinkRecipe) -> bool:
	if base != other_recipe.base:
		return false
	# comparar se dois vetores de mesmo tamanho tem os mesmos itens
	for item in additives:
		if additives.count(item) != other_recipe.additives.count(item):
			return false
	return true


func _validate_base(base_ingredient:Ingredient) -> bool:
	var invalid := false
	
	if base_ingredient == null:
		errors[Errors.NULL_BASE] = true
		invalid = true
	elif not base_ingredient.is_base:
		errors[Errors.BASE_IS_NOT_BASE] = true
		invalid = true
	
	return (not invalid)


func _validate_additives(additives_array:Array[Ingredient]) -> bool:
	var invalid := false
	
	if additives_array.size() != 2:
		errors[Errors.INCORRECT_AMOUNT_OF_ADDITIVES] = true
		invalid = true
	
	for ingredient in additives_array:
		# leite pode ser usado como aditivo
		if ingredient.is_milk: continue
		# testar se outra base foi incluída
		if ingredient.is_base:
			if ingredient != base:
				errors[Errors.USING_BASE_AS_ADDITIVE] = true
				invalid == true
	
	return (not invalid)


func _to_string():
	return "%s: [%s, %s, %s]" % [name, base.name, additives[0].name, additives[1].name]

