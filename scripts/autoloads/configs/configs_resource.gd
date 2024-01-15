class_name ConfigsResource
extends Resource
## Fonte: https://www.youtube.com/watch?v=GPzdFzNq060
## Todas as variáveis devem ter valores padrão.

@export_category("Video Settings")

@export var WINDOW_WIDTH : int = 1920
@export var WINDOW_HEIGHT : int = 1080
@export var WINDOW_DISPLAY_MODE := Window.Mode.MODE_FULLSCREEN

## https://godotengine.org/article/godot-40-gets-global-and-instance-shader-uniforms/
## Ligar e desligar global uniforms de shaders.
@export var SHADER_DITHERING_ENABLED := false

@export_category("Audio Settings")

# master volume 50%
# music volume
# sfx volume
# ambient subtitles?

@export_category("Gameplay Settings")

# text speed
# dyslexic font: https://fontstruct.com/fontstructions/show/1300555/dyslexic-pixelated
# language



func save() -> void:
	ResourceSaver.save(self, "user://configs.tres")
