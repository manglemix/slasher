extends Node


const packed_future := preload("res://future_level/future.tscn")

signal player_changed
signal switching_past

var player: Character setget set_character
var camera_base: Spatial
var enemies: Array
var ui: Node


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
	var past_scene := get_tree().current_scene
	var old_children := []
	
	for child in past_scene.get_children():
		if child != player and child != camera_base and child != ui:
			old_children.append(child)
			past_scene.remove_child(child)
	
	var future_scene := packed_future.instance()
	get_tree().root.add_child(future_scene)
	get_tree().current_scene = future_scene
	
	yield(self, "switching_past")
	
	for child in old_children:
		past_scene.add_child(child)
	
	future_scene.queue_free()
	get_tree().current_scene = past_scene


func switch_past() -> void:
	emit_signal("switching_past")
