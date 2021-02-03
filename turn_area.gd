class_name TurnArea
extends Area


export var glide_time := 0.3
export var new_rotation: float

onready var player: Character = GlobalStuff.yield_and_get_group("Player")[0]
onready var camera_base: Spatial = GlobalStuff.yield_and_get_group("CameraBase")[0]


func _ready():
	# warning-ignore-all:return_value_discarded
	set_process_input(false)
	connect("body_entered", self, "_handle_body_entered")
	connect("body_exited", self, "_handle_body_exited")


func _handle_body_entered(body: Node) -> void:
	if body == player:
		camera_base.target_orientation = deg2rad(new_rotation)


func _handle_body_exited(body: Node) -> void:
	if body == player and camera_base.target_orientation == deg2rad(new_rotation):
		camera_base.target_orientation = 0
