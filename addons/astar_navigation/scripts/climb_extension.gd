class_name ClimbExtension
extends TravelExtension


export var _jump_path: NodePath = "../../CharacterJump"
export var jump_flag := "jump"

onready var jump_node: CharacterJump = get_node(_jump_path)


func _ready():
	connect("execution_flag", self, "trigger_jump")


func trigger_jump(flag, _node) -> void:
	if flag == jump_flag:
		jump_node.jumping = true
