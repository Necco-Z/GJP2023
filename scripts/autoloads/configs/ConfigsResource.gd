class_name ConfigsResource
extends Resource
## Fonte: https://www.youtube.com/watch?v=GPzdFzNq060
## Todas as variáveis devem ter valores padrão.


@export var WINDOW_WIDTH : int = 1920
@export var WINDOW_HEIGHT : int = 1080

@export var WINDOW_DISPLAY_MODE := Window.Mode.MODE_FULLSCREEN


func save() -> void:
	ResourceSaver.save(self, "user://configs.tres")


static func load_or_create() -> ConfigsResource:
	var resource : ConfigsResource = load("user://configs.tres") as ConfigsResource
	if not resource:
		resource = ConfigsResource.new()
	return resource
