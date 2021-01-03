class_name TwoDStyleCharacter
extends ClassicCharacter


export var movement_path: NodePath = "CharacterMovement"

onready var movement: CharacterMovement = get_node(movement_path)


func turn(angle:=PI) -> void:
    global_rotate(Vector3.UP, angle)
    movement.target_basis = global_transform.basis


func turn_to(angle:=PI) -> void:
    turn(angle - global_transform.basis.get_euler().y)
