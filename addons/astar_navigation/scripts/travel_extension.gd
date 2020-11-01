# A base class for developing scripts which respond to link flags
class_name TravelExtension
extends Node


export var desired_flag: String		# The name of the flag which this script responds to

onready var flagged_goto: FlaggedGoto = get_parent()


func _ready():
	flagged_goto.connect("flag_reached", self, "_check_flag")


func _triggered(_node: Node):
	# Called when the desired_flag is reached by the parent (FlaggedGoto)
	return


func _check_flag(flag: LinkFlag, node: Node) -> void:
	if flag.name == desired_flag:
		_triggered(node)
