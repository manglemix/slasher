class_name TurnArea
extends Area


func _ready():
	connect("body_entered", self, "_handle_body_entered")
	connect("body_exited", self, "_handle_body_exited")


func _handle_body_entered(body: Node) -> void:
	if body == GlobalStuff.player:
		GlobalStuff.ui.turn.show()


func _handle_body_exited(body: Node) -> void:
	if body == GlobalStuff.player:
		GlobalStuff.ui.turn.hide()
