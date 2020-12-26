extends Control


var _index: int
var _mouse_clicked := false


func _ready():
	set_process_input(false)
	hide()


func _input(event):
	if event is InputEventScreenTouch and not event.pressed and event.index == _index:
		_mouse_clicked = false
		set_process_input(false)


func _gui_input(event):
	if _mouse_clicked or not visible:
		return
	
	elif event is InputEventScreenTouch and event.pressed:
		get_tree().set_input_as_handled()
		_mouse_clicked = true
		_index = event.index
		set_process_input(true)
		event = InputEventAction.new()
		GlobalStuff.player.turn(PI / 2)
		GlobalStuff.camera_base.global_rotate(Vector3.UP, PI/2)
