extends Node


const future_scene := preload("res://future.tscn")

signal player_changed

var player: Character setget set_character
var camera_base: Spatial
var ui: Node

var _past_scene: Node
var _original_player_origin: Vector3


func set_character(node: Character) -> void:
	player = node
	emit_signal("player_changed")


func trigger_event(name: String, pressed: bool, strength:=1.0) -> InputEventAction:
	var event := InputEventAction.new()
	event.action = name
	event.pressed = pressed
	event.strength = strength
	Input.parse_input_event(event)
	return event


func switch_future() -> void:
	_past_scene = get_tree().current_scene
	_past_scene.remove_child(player)
	_past_scene.remove_child(camera_base)
	_past_scene.remove_child(ui)
	
	get_tree().root.remove_child(_past_scene)
	var current_scene := future_scene.instance()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
	
	current_scene.add_child(player)
	current_scene.add_child(camera_base)
	current_scene.add_child(ui)


func switch_past() -> void:
	var current_scene := get_tree().current_scene
	current_scene.remove_child(player)
	current_scene.remove_child(camera_base)
	current_scene.remove_child(ui)
	
	get_tree().root.remove_child(current_scene)
	get_tree().root.add_child(_past_scene)
	get_tree().current_scene = _past_scene
	
	_past_scene.add_child(player)
	_past_scene.add_child(camera_base)
	_past_scene.add_child(ui)
