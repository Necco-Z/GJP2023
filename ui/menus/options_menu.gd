extends Control


var resolutions_dict : Dictionary = {
	"1920x1080": {"w": 1920, "h":1080},
	"1360x768": {"w": 1360, "h":768},
	"1280x720": {"w": 1280, "h":720},
}


# Called when the node enters the scene tree for the first time.
func _ready():
	$BtnReturn.grab_focus()
	#await %TabContainer.ready
	load_configs_into_tabs()


func _on_btn_return_pressed():
	apply_video_changes()
	ConfigsManager.save_configs()
	Loader.load_scene("res://ui/main_menu.tscn")


func load_configs_into_tabs() -> void:
	load_video_configs()
	#load_audio_configs()
	#load_gameplay_configs()


func load_video_configs() -> void:
	var configs = ConfigsManager.configs
	
	#### WINDOW ####
	var res_btn : OptionButton = %ScreenResolution/Option
	var res_string := "%dx%d" % [configs.WINDOW_WIDTH, configs.WINDOW_HEIGHT]
	for index in range(res_btn.item_count):
		if res_btn.get_item_text(index) == res_string:
			res_btn.select(index)
			break
	var display_btn = %DisplayMode/Option
	for index in range(display_btn.item_count):
		if display_btn.get_item_id(index) == configs.WINDOW_DISPLAY_MODE:
			display_btn.select(index)
			break
	
	#### SHADERS ####
	%ShaderDithering/CheckButton.button_pressed = configs.SHADER_DITHERING_ENABLED
	%ShaderScanlines/CheckButton.button_pressed = configs.SHADER_SCANLINES_ENABLED



func apply_video_changes() -> void:
	var configs = ConfigsManager.configs
	
	#### WINDOW ####
	var chosen_resolution = %ScreenResolution/Option.get_item_text(%ScreenResolution/Option.selected)
	configs.WINDOW_WIDTH = resolutions_dict[chosen_resolution].w
	configs.WINDOW_HEIGHT = resolutions_dict[chosen_resolution].h
	configs.WINDOW_DISPLAY_MODE = %DisplayMode/Option.get_selected_id()
	
	#if configs.WINDOW_DISPLAY_MODE == Window.Mode.MODE_FULLSCREEN:
	#	%ScreenResolution/Option.disabled = true
	#else:
	#	%ScreenResolution/Option.disabled = false
	
	#### SHADERS ####
	configs.SHADER_DITHERING_ENABLED = %ShaderDithering/CheckButton.button_pressed
	configs.SHADER_SCANLINES_ENABLED = %ShaderScanlines/CheckButton.button_pressed
	
	ConfigsManager.apply_video_settings()






func _on_video_option_item_selected(index):
	apply_video_changes()


func _on_video_option_button_pressed():
	apply_video_changes()
