class_name AStarGoto
extends Node


signal targeted
signal untargeted

export var navigation_path: NodePath = "../../Navigation"
export var character_movement_path: NodePath
export var simplify_distance := 0.0
export var stop_on_arrival := false

var target: Node setget set_target
var override_target: Node setget set_override_target
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


func set_override_target(node: Node) -> void:
	if is_instance_valid(target):
		override_target = node
	
	else:
		set_target(override_target)


func _ready():
	set_process(false)


func update_path():
	var character_origin = character.global_transform.origin
	var target_origin
	
	if is_instance_valid(override_target):
		target_origin = override_target.global_transform.origin
	
	else:
		target_origin = target.global_transform.origin
	
	if (stop_on_arrival or is_instance_valid(override_target)) and target_origin.distance_to(character_origin) <= simplify_distance:
		if is_instance_valid(override_target):
			override_target = null
		
		else:
			set_target(null)
		
		return
	
	id_path = navigation.get_id_path(character_origin, target_origin)
	path = navigation.id_path_to_vector_path(id_path)
	
	if not path.empty() and navigation.a_star.get_closest_position_in_segment(character_origin).distance_to(path[0]) <= simplify_distance:
		path.remove(0)
	
	path.insert(0, character_origin)
	path.append(target_origin)
	
	character_movement.movement_vector = (path[1] - character_origin).normalized()


func _process(_delta):
	update_path()
