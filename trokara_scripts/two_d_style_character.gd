class_name TwoDStyleCharacter
extends ClassicCharacter


signal turned

export var animator_path: NodePath = "CharacterAnimator"
export var turn_anim_name := "turn-loop"
export var movement_path: NodePath = "CharacterMovement"

var turning := false

onready var animator: CharacterAnimator = get_node(animator_path)
onready var movement: CharacterMovement = get_node(movement_path)


func turn(angle:=PI) -> void:
	turning = true
#	movement.targeting = false
	animator.override_play(turn_anim_name)
	yield(animator, "animation_finished")
	rotate_object_local(Vector3.UP, angle)
	animator.play("turn-loop")
	movement.target_basis = global_transform.basis
	emit_signal("turned")
#	movement.targeting = true
	turning = false
