class_name MobileCamera
extends Camera2D


enum TargetingStyle {FACE_MOUSE, FACE_TARGET}

export(TargetingStyle) var targeting_style := TargetingStyle.FACE_MOUSE
export var targeting_weight := 0.2
export var targeting := true
export var inertia_weight := 10.0
export var _target_path: NodePath
export var target_position_only := false
export var _parent_path: NodePath

var target

onready var original_transform := transform
onready var parent: Node2D = get_node(_parent_path)


func _ready():
	if not _target_path.is_empty():
		target = get_node(_target_path)


func _process(delta):
	original_transform = original_transform.interpolate_with(parent.global_transform, inertia_weight * delta)
	transform = original_transform
	
	if targeting:
		if targeting_style == TargetingStyle.FACE_MOUSE:
			target = get_global_mouse_position()
		
		if typeof(target) == TYPE_VECTOR2:
			global_transform.origin = global_transform.origin.linear_interpolate(target, targeting_weight)
		
		elif target_position_only:
			global_transform.origin = global_transform.origin.linear_interpolate(target.global_transform.origin, targeting_weight)
		
		else:
			global_transform = global_transform.interpolate_with(target.global_transform, targeting_weight)
