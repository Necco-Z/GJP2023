class_name Ingredient
extends Resource
## Cada um dos ingredientes que podem ser misturados em bebidas.

## Nome da bebida.
@export var name : String
## Ícone da bebida.
@export var icon : Texture2D
## Se o ingrediente tal é líquido e pode ter bebidas feitas apenas dele como base.
@export var is_base : bool = false
## Se o ingrediente é base mas pode ser incluido como aditivo em outras receitas,
## como por exemplo o Leite.
@export var can_be_additive : bool = false

@export_category("Flavor Aspects")

enum Aspects {SWEET=0, BITTER=1, SMOOTH=2, WARM=3, FRESH=4}

@export var aspects_dict : Dictionary = {
		Aspects.SWEET: 0, Aspects.BITTER: 0, Aspects.SMOOTH: 0, Aspects.WARM: 0, Aspects.FRESH: 0,
}
