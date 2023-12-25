class_name Ingredient
extends Resource
## Cada um dos ingredientes que podem ser misturados em bebidas.

## Nome da bebida.
@export var name : String

#@export var icon : Texture

## Se o ingrediente tal é líquido e pode ter bebidas feitas apenas dele como base.
@export var is_base : bool = false

@export_category("Flavor Aspects")
@export var flavor_sweet : int = 0
@export var flavor_bitter : int = 0
@export var flavor_smooth : int = 0
@export var flavor_warm : int = 0
@export var flavor_fresh : int = 0
