class_name Lerper
extends Node2D


export var _target_path: NodePath
export var weight := 0.15

onready var parent: Node2D = get_parent()
onready var target: Node2D = get_node(_target_path)


func _physics_process(_delta):
	global_transform.origin = parent.global_transform.origin.linear_interpolate(target.global_transform.origin, weight)
