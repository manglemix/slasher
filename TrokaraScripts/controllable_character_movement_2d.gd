# A version of CharacterMovement which can accept user input
class_name ControllableCharacterMovement2D
extends CharacterMovement2D


func _ready():
	set_process_input(not OS.has_touchscreen_ui_hint())


func _input(event):
	movement_vector = Vector2(
			Input.get_action_strength("move right") - Input.get_action_strength("move left"),
			Input.get_action_strength("move up") - Input.get_action_strength("move down")
		).normalized()
