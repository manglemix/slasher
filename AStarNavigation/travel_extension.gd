class_name TravelExtension
extends Node


export var desired_flag: String

onready var flag_checker: FlaggedGoto = get_parent()


func _ready():
	flag_checker.connect("execution_flag", self, "_check_flag")


func _triggered(_node: Node):
	return


func _check_flag(flag, node: Node) -> void:
	if flag == desired_flag:
		_triggered(node)
