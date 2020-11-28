extends Node2D


const ORIGINAL_HEIGHT := 600

export var padding := 10.0
export var max_distance := 100.0
export var return_weight := 20.0
export var sensing_distance := 150.0

var size_factor: float
var player: Character2D
var player_movement: CharacterMovement2D

var _mouse_moving := false

onready var original_origin := transform.origin
onready var camera: Camera2D = get_parent().get_parent()
onready var viewport_size := get_viewport().size
onready var parent_radius: float = get_parent().mesh.radius


func _ready():
	var scene := get_tree().current_scene
	set_process(false)
	yield(scene, "ready")
	
	player = scene.player
	player_movement = player.get_node("CharacterMovement2D")
	set_process(true)


func _input(event):
	if _mouse_moving and event is InputEventMouseMotion:
		var look_vector: Vector2 = get_global_mouse_position() - get_parent().global_transform.origin
		player_movement.movement_vector = look_vector.normalized()
		transform.origin = original_origin + (look_vector / size_factor).clamped(max_distance)
	
	elif event is InputEventMouseButton and event.button_index == 1:
		if event.pressed:
			if get_global_mouse_position().distance_to(get_parent().global_transform.origin) <= sensing_distance * size_factor:
				_mouse_moving = true
		
		else:
			_mouse_moving = false
			player_movement.movement_vector = Vector2.ZERO


func _process(delta):
	if not _mouse_moving:
		transform.origin = transform.origin.linear_interpolate(original_origin, return_weight * delta)
	
	size_factor = viewport_size.y / ORIGINAL_HEIGHT * (camera.zoom.x + camera.zoom.y) / 2
	get_parent().scale = Vector2(size_factor, size_factor)
	get_parent().transform.origin = Vector2((padding + parent_radius) * size_factor - viewport_size.x / 2 * camera.zoom.x, viewport_size.y / 2 * camera.zoom.y - (padding + parent_radius) * size_factor)
