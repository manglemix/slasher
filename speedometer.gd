# A simple label designed to show the speed of its parent
class_name Speedometer
extends Label


onready var target = get_parent()
onready var _last_origin = target.global_transform.origin


func _physics_process(delta):
	text = target.name + " speed: " + str(_last_origin.distance_to(target.global_transform.origin) / delta)
	_last_origin = target.global_transform.origin
