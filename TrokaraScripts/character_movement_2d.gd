class_name CharacterMovement2D
extends Node


enum RotationStyles {FACE_MOUSE, FACE_NODE, FACE_MOVEMENT, FACE_ORIGIN}

export var default_speed := 5.0
export var auto_rotate := true			# If true, the body_node will be flipped to according to rotation_style

# The direction the body_node will face when moving
# FACE_MOUSE will turn towards the mouse
# FACE_NODE will turn towards target_node
# FACE_MOVMENT will turn towards the movement_vector
# FACE_ORIGIN will turn towards the target_origin
export(RotationStyles) var rotation_style := RotationStyles.FACE_MOVEMENT
export var counter_rotate_basis := true								# Counter rotates the basis_node so that it is not affected by auto_rotate
export var basis_node_path: NodePath = ".."							# The node which the movement vector will be relative to (modifying after _ready has no effect)
export var body_node_path: NodePath									# The node which will be flipped to follow the movement_vector (modifying after _ready has no effect)
export var target_node_path: NodePath								# The node which the body node will face (for FACE_NODE)
export var target_origin: Vector2									# The position in global space the body node will face (for FACE_ORIGIN)

var movement_vector: Vector2
var target_node: Node2D
var rotate_once := false

# Modify these after _ready if need be, instead of basis_node_path
onready var basis_node: Node2D = get_node(basis_node_path)
onready var body_node: Node2D = get_node(body_node_path)
onready var character: Character2D = get_parent()


func _ready():
	if not target_node_path.is_empty():
		target_node = get_node(target_node_path)


func flip_body_node() -> void:
	body_node.global_transform.x *= -1


func _process(_delta):
	var tmp_vector = (basis_node.to_global(movement_vector) - basis_node.global_transform.origin) * default_speed
	character.movement_vector = tmp_vector
	
	if auto_rotate:
		var local_origin: Vector2
		
		if rotate_once:
			auto_rotate = false
		
		match rotation_style:
			RotationStyles.FACE_MOUSE:
				local_origin = body_node.get_global_mouse_position()
			
			RotationStyles.FACE_NODE:
				local_origin = target_node.global_transform.origin
			
			RotationStyles.FACE_MOVEMENT:
				local_origin = tmp_vector + body_node.global_transform.origin
			
			RotationStyles.FACE_ORIGIN:
				local_origin = target_origin
		
		if body_node.to_local(local_origin).x < 0:
			body_node.global_transform.x *= -1
