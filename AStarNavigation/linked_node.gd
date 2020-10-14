class_name LinkedNode
extends Node


export(Array, NodePath) var link_paths: Array
export(Array) var _link_flags: Array
export(Array, float) var _flag_distance: Array


var links: Dictionary
var id: int


func _ready():
	for i in range(link_paths.size()):
		var node := get_node(link_paths[i])
		
		if is_linked_node(node):
			var flag
			if _link_flags.size() > i:
				flag = _link_flags[i]
			
			var flag_distance := 1.0
			if _flag_distance.size() > i:
				flag_distance = _flag_distance[i]
			
			add_link(node, flag, flag_distance)


func add_link(node: Node, flag=null, flag_distance=1.0) -> void:
	links[node] = [flag, flag_distance]
	
	if not node in links and is_linked_node(node):
		node.add_link(self)


static func is_linked_node(node: Node) -> bool:
	return "id" in node and "links" in node and node.has_method("add_link")
