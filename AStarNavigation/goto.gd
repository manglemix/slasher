class_name Goto
extends Node


export var navigation_path: NodePath = "../../Navigation"
export var character_movement_path: NodePath

var target: Node setget set_target
var path

onready var navigation = get_node(navigation_path)
onready var character_movement = get_node(character_movement_path)
onready var character = character_movement.character


func set_target(node: Node) -> void:
	target = node
	set_process(is_instance_valid(target))


func _ready():
	set_process(false)


func _process(_delta):
	var character_origin = character.global_transform.origin
	path = navigation.get_simple_path(character_origin, target.global_transform.origin)
	character_movement.movement_vector = (path[1] - character_origin).normalized()
