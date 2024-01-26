extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	refresh_shaders()
	pass


func refresh_shaders() -> void:
	%Dithering.visible = ConfigsManager.configs.SHADER_DITHERING_ENABLED
	
	%TV.visible = ConfigsManager.configs.SHADER_SCANLINES_ENABLED
	%Blur.visible = ConfigsManager.configs.SHADER_SCANLINES_ENABLED
