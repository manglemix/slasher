class_name WormholeArea
extends Area


export var to_future := true

onready var player: Character = GlobalStuff.yield_and_get_group("Player")[0]
onready var ui: Node = GlobalStuff.yield_and_get_group("UI")[0]


func _ready():
	# warning-ignore-all:return_value_discarded
	set_process_input(false)
	connect("body_entered", self, "_handle_body_entered")
	connect("body_exited", self, "_handle_body_exited")


func _handle_body_entered(body: Node) -> void:
	if body == player:
		set_process_input(true)
		ui.turn.show()


func _handle_body_exited(body: Node) -> void:
	if body == player:
		set_process_input(false)
		ui.turn.hide()


func _input(event):
	if event.is_action_pressed("transition"):
		if to_future:
			GlobalStuff.switch_future()
		
		else:
			GlobalStuff.switch_past()
