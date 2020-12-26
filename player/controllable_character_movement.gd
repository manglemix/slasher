# A version of CharacterMovement which can accept user input
class_name ControllableCharacterMovement
extends CharacterMovement


func _ready():
	set_process_input(not OS.has_touchscreen_ui_hint())


func _input(_event):
	movement_vector = Vector3(
			Input.get_action_strength("move right") - Input.get_action_strength("move left"),
			0,
			0
		).normalized()
