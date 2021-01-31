class_name TurnArea
extends Area


export var glide_time := 0.3
export var new_rotation: float


func _ready():
	# warning-ignore-all:return_value_discarded
	set_process_input(false)
	connect("body_entered", self, "_handle_body_entered")
	connect("body_exited", self, "_handle_body_exited")


func _handle_body_entered(body: Node) -> void:
	if body == GlobalStuff.player:
		GlobalStuff.camera_base.target_orientation = deg2rad(new_rotation)


func _handle_body_exited(body: Node) -> void:
	if body == GlobalStuff.player and GlobalStuff.camera_base.target_orientation == deg2rad(new_rotation):
		GlobalStuff.camera_base.target_orientation = 0
