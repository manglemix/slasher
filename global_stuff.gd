extends Node


signal player_changed


var player: Character setget set_character
var camera_base: Spatial
var ui: Node


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
