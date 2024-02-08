extends Node
## ConfigsManager

var configs : ConfigsResource = null
var configs_dir := "user://configs.tres"


# Called when the node enters the scene tree for the first time.
func _ready():
	configs = load_or_create()
	apply_configs()


func load_or_create() -> ConfigsResource:
	var resource : ConfigsResource
	if FileAccess.file_exists(configs_dir):
		resource = load(configs_dir) as ConfigsResource
	if not resource:
		resource = ConfigsResource.new()
	return resource


func reset_configs() -> void:
	configs = ConfigsResource.new()
	configs.save()
	apply_configs()


func save_configs() -> void:
	configs.save()


func apply_configs() -> void:
	apply_video_settings()
	#apply_audio_settings()
	#apply_gameplay_settings()
	pass


func apply_video_settings() -> void:
	var window = get_window()
	
	window.size = Vector2i(configs.WINDOW_WIDTH, configs.WINDOW_HEIGHT)
	window.mode = configs.WINDOW_DISPLAY_MODE
	window.move_to_center()
	
	RenderingServer.global_shader_parameter_set("DITHERING_ENABLED",
			configs.SHADER_DITHERING_ENABLED)
	RenderingServer.global_shader_parameter_set("SCANLINES_ENABLED",
			configs.SHADER_SCANLINES_ENABLED)


