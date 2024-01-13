extends Node



var configs : ConfigsResource = null

# Called when the node enters the scene tree for the first time.
func _ready():
	configs = ConfigsResource.load_or_create()
	apply_configs()


func apply_configs() -> void:
	apply_video_settings()
	#apply_audio_settings()
	#apply_gameplay_settings()
	pass


func apply_video_settings() -> void:
	var window = get_window()
	
	window.size = Vector2i(configs.WINDOW_WIDTH, configs.WINDOW_HEIGHT)
	window.mode = configs.WINDOW_DISPLAY_MODE
