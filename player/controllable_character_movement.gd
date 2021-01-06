# A version of CharacterMovement which can accept user input
class_name ControllableCharacterMovement
extends CharacterMovement


func _input(_event):
	movement_vector = Vector3(
			Input.get_action_strength("move right") - Input.get_action_strength("move left"),
			0,
			Input.get_action_strength("move down") - Input.get_action_strength("move up")
		)
	
	if movement_vector.length() > 1:
		movement_vector = movement_vector.normalized()
