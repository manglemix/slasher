class_name TerrestrialTraversing
extends TravelExtension


export var _jump_path: NodePath = "../../CharacterJump"

onready var jump_node: CharacterJump = get_node(_jump_path)


func _triggered(_node: Node):
	jump_node.jumping = true
