class_name NodeFlag
extends Node


export var property_name: String


func _enter_tree():
	GlobalStuff.set(property_name, get_parent())
