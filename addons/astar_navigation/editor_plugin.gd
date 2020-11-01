tool
extends EditorPlugin


const icon := preload("res://neutral.png")

var plugin: EditorInspectorPlugin = preload("inspector_plugin.gd").new()
var custom_types: Array


func _enter_tree():
	add_inspector_plugin(plugin)
	var directory := Directory.new()
	var folder_path := "res://addons/linked_tree/custom_resources/"
	directory.open(folder_path)
	directory.list_dir_begin()
	var path := directory.get_next()
	while not path.empty():
		if path.ends_with(".gd"):
			var type := path.left(path.length() - 3)
			add_custom_type(type, "Resource", load(folder_path + path), icon)
			custom_types.append(type)
		
		path = directory.get_next()


func _exit_tree():
	remove_inspector_plugin(plugin)
	for type in custom_types:
		remove_custom_type(type)
