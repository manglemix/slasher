class_name CameraBase
extends Lerper


export var target_orientation := 0.0


func _ready():
	GlobalStuff.camera_base = self


func _process(delta):
	rotation.y = lerp(rotation.y, target_orientation, weight * delta)
