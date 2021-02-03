extends CanvasLayer


export var attack_path: NodePath = "AttackBase"
export var joystick_path: NodePath = "JoystickBase"
export var jump_path: NodePath = "JumpButton"
export var turn_path: NodePath = "TurnButton"

onready var attack := get_node(attack_path)
onready var joystick := get_node(joystick_path)
onready var jump := get_node(jump_path)
onready var turn := get_node(turn_path)
