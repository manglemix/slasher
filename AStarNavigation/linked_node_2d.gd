class_name LinkedNode2D
extends Node2D


export(Array, NodePath) var link_paths: Array

var links: Array
var id: int


func _ready():
	for path in link_paths:
		var node := get_node(path)
		
		if "id" in node:
			add_link(node)


func add_link(node: Node) -> void:
	if not node in links:
		links.append(node)
		
		if node.has_method("add_link"):
			node.add_link(self)
