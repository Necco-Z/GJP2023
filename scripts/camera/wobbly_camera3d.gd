extends Camera3D

@export var wobble_strength : float = 0.01
@export var wobble_speed : float = 0.2

@export var wobble_sine_multiplier : float = 1.3

var timer : float = 0.0
var target_offset := Vector2.ZERO

var lifetime : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	lifetime += delta * wobble_sine_multiplier
	if lifetime >= 2*PI: 
		lifetime -= 2*PI
	
	v_offset = 0 + sin(lifetime) * wobble_strength
	
	#timer -= delta
	#if timer <= 0:
	#	timer += 0.5 + randf()*1
	#	target_offset = get_random_offset()
	
	#h_offset = lerpf(h_offset, target_offset.x, wobble_speed * delta)
	#v_offset = lerpf(v_offset, target_offset.y, wobble_speed * delta)


func get_random_offset() -> Vector2:
	return Vector2(randf_range(-1,1)*wobble_strength ,randf_range(-1,1)*wobble_strength)
