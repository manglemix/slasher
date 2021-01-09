extends Node


const future_scene := preload("res://future.tscn")

signal player_changed

var player: Character setget set_character
var ui: Node
var enemies: Array
var camera_base: Spatial
var secondary_viewport: Viewport

var _past_scene: Node
var _original_player_origin: Vector3
var _background: Background


func set_character(node: Character) -> void:
	player = node
	emit_signal("player_changed")


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()


func trigger_event(name: String, pressed: bool, strength:=1.0) -> InputEventAction:
	var event := InputEventAction.new()
	event.action = name
	event.pressed = pressed
	event.strength = strength
	Input.parse_input_event(event)
	return event


func switch_future() -> void:
	_past_scene = secondary_viewport.get_child(0)
	_past_scene.remove_child(player)
	_past_scene.remove_child(camera_base)
	_background = get_tree().current_scene.get_node("Background")
	get_tree().current_scene.remove_child(_background)
	
	secondary_viewport.remove_child(_past_scene)
	var current_scene := future_scene.instance()
	secondary_viewport.add_child(current_scene)
	secondary_viewport.move_child(current_scene, 0)
	
	current_scene.add_child(player)
	current_scene.add_child(camera_base)


func switch_past() -> void:
	var current_scene := secondary_viewport.get_child(0)
	current_scene.remove_child(player)
	current_scene.remove_child(camera_base)
	
	secondary_viewport.remove_child(current_scene)
	secondary_viewport.add_child(_past_scene)
	secondary_viewport.move_child(_past_scene, 0)
	
	_past_scene.add_child(player)
	_past_scene.add_child(camera_base)
	_past_scene.add_child(_background)
#	yield(_past_scene, "tree_entered")
