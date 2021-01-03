# Gives 4 state movement functionality to the parent character
# The character will be able to sprint, run, walk or air strafe with this script
# Also provides user input support
class_name CharacterMovement
extends Node


enum RotationStyles {COPY_BASIS, FACE_MOVEMENT}
enum {DEFAULT, SLOW, FAST}

export var sprint_speed := 10.0
export var default_speed := 5.0
export var walk_speed := 2.5
export var targeting := true
export var auto_rotate := true			# If true, the character will rotate according to the rotation_style when moving
export var continuously_rotate := false
export var auto_rotate_weight := 6.0	# The weight used to interpolate the rotation of the character

# The direction the character will face when moving
# FACE_MOVMENT will turn towards the movement_vector
# COPY_BASIS will turn towards the - z axis of the basis_node
export(RotationStyles) var rotation_style := RotationStyles.FACE_MOVEMENT
export var counter_rotate_basis := true								# Counter rotates the basis_node so that it is not affected by auto_rotate
export var basis_node_path: NodePath = ".."							# The node which the movement vector will be relative to (modifying after _ready has no effect)
export var dont_xform := false

var movement_state := DEFAULT		# Corresponds to the speed that the character will move at
var movement_vector: Vector3		# The vector towards which the character will move to, within the local space of the basis_node
var target_basis: Basis

var _last_movement_vector: Vector3

onready var basis_node: Spatial = get_node(basis_node_path)		# Modify this after _ready if need be, instead of basis_node_path
onready var character: Character = get_parent()


func target_origin(origin: Vector3) -> bool:
    var local_vector := character.to_local(origin)
    if local_vector.x != 0 or local_vector.z != 0:
        target_basis = character.global_transform.looking_at(origin, character.global_transform.basis.y).basis
        return true
    
    else:
        return false


func target_local_origin(origin: Vector3) -> bool:
    return target_origin(character.to_global(origin))


func reset_target_basis() -> void:
    target_basis = character.global_transform.basis


func _process(delta):
    var tmp_vector: Vector3
    
    if dont_xform:
        tmp_vector = movement_vector
    else:
        tmp_vector = basis_node.global_transform.basis.xform(movement_vector)
    
    match movement_state:
        FAST:
            tmp_vector *= sprint_speed
        
        SLOW:
            tmp_vector *= walk_speed
        
        _:
            tmp_vector *= default_speed
    
    character.movement_vector = tmp_vector
    
    if targeting:
        if auto_rotate and not (is_zero_approx(tmp_vector.length_squared()) and continuously_rotate):
            match rotation_style:
                RotationStyles.COPY_BASIS:
                    target_basis = basis_node.global_transform.basis
                
                RotationStyles.FACE_MOVEMENT:
                    if not target_origin(character.global_transform.origin + tmp_vector):
                        reset_target_basis()
        
        var original_basis: Basis
        if counter_rotate_basis:
            original_basis = basis_node.global_transform.basis
        
        character.global_transform = character.global_transform.interpolate_with(Transform(target_basis, character.global_transform.origin), auto_rotate_weight * delta)
        
        if counter_rotate_basis:
            basis_node.global_transform.basis = original_basis
    
