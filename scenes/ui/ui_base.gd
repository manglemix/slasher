tool
class_name UIBase
extends CanvasFollower


export var proxy_dimensions := Vector2(1024, 600)

onready var original_dimensions := Vector2(ProjectSettings.get_setting("display/window/size/width"), ProjectSettings.get_setting("display/window/size/height"))
