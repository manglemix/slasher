# This script should be used by Area (2D and 3D), to override the target of the pathfinding of the bodies inside
class_name PathOverrideZone
extends PathTrigger


export var _override_target_path: NodePath

onready var override_target := get_node(_override_target_path)


func _triggered(body: Node) -> void:
	var node = body.get_node_or_null(pathfinder_name)
	if is_instance_valid(node):
		node.override_target = override_target
