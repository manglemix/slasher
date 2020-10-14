class_name AStarGoto
extends Node


signal targeted
signal untargeted


export var navigation_path: NodePath = "../../Navigation"
export var character_movement_path: NodePath

var target: Node setget set_target
var id_path: PoolIntArray
var path

onready var navigation: AStarNavigation = get_node(navigation_path)
onready var character_movement := get_node(character_movement_path)
onready var character: Node = character_movement.character


func set_target(node: Node) -> void:
	target = node
	if is_instance_valid(target):
		set_process(true)
		emit_signal("targeted")
	
	else:
		set_process(false)
		emit_signal("untargeted")


func _ready():
	set_process(false)


func _process(_delta):
	var character_origin = character.global_transform.origin
	var target_origin = target.global_transform.origin
	id_path = navigation.get_id_path(character_origin, target_origin)
	path = navigation.id_path_to_vector_path(id_path)
	path.insert(0, character_origin)
	path.append(target_origin)
	character_movement.movement_vector = (path[1] - character_origin).normalized()
