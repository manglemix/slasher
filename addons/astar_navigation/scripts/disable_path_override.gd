# Disables any override in the parent Area's bodies' pathfinders
class_name DisablePathOverride
extends Node


export var pathfinder_name := "Goto"


func _ready():
	get_parent().connect("_triggered", self, "_triggered")


func _triggered(body: Node):
	var node := body.get_node_or_null(pathfinder_name)
	if is_instance_valid(node):
		node.override_target = null
