class_name WormholeArea
extends Area


func _ready():
	set_process_input(false)
	connect("body_entered", self, "_handle_body_entered")
	connect("body_exited", self, "_handle_body_exited")


func _handle_body_entered(body: Node) -> void:
	if body == GlobalStuff.player:
		set_process_input(true)
		GlobalStuff.ui.turn.show()


func _handle_body_exited(body: Node) -> void:
	if body == GlobalStuff.player:
		set_process_input(false)
		GlobalStuff.ui.turn.hide()


func _input(event):
	if event.is_action_pressed("transition"):
		GlobalStuff.switch_future()