class_name LinkedNode
extends Node


export(Array, NodePath) var link_paths: Array
export(Array, Resource) var flags: Array

var links: Dictionary
var id: int


func _ready():
	for i in range(link_paths.size()):
		var to_node: LinkedNode = get_node(link_paths[i])
		
		if i < flags.size():
			links[to_node] = flags[i]
		
		else:
			links[to_node] = null
		
		if not self in to_node.links:
			to_node.links[self] = null
