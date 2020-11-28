extends Node2D


export var weight := 5.0

onready var scene := get_parent()


func _ready():
	yield(scene, "ready")
	global_transform.origin = scene.player.global_transform.origin


func _process(delta):
	var origin: Vector2 = scene.player.global_transform.origin
	var i := 1
	for enemy in scene.enemies:
		if enemy.get_node("VisibilityNotifier2D").is_on_screen():
			origin += enemy.global_transform.origin
			i += 1
	origin /= i
	global_transform.origin = global_transform.origin.linear_interpolate(origin, weight * delta)
