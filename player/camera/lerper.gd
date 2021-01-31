class_name Lerper
extends Spatial


export var _target_path: NodePath
export var _basis_target_path: NodePath = ".."
export var weight := 12.0

onready var basis: Spatial = get_node(_basis_target_path)
onready var target: Spatial = get_node(_target_path)


func _physics_process(delta):
	global_transform.origin = basis.global_transform.origin.linear_interpolate(target.global_transform.origin, weight * delta)
