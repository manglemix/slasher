extends Control


var _index: int
var _mouse_clicked := false


func _ready():
	set_process_input(false)
	hide()


func _input(event):
	# warning-ignore-all:return_value_discarded
	if event is InputEventScreenTouch and not event.pressed and event.index == _index:
		_mouse_clicked = false
		set_process_input(false)
		GlobalStuff.trigger_event("transition", false)


func _gui_input(event):
	# warning-ignore-all:return_value_discarded
	if _mouse_clicked or not visible:
		return
	
	elif event is InputEventScreenTouch and event.pressed:
		get_tree().set_input_as_handled()
		GlobalStuff.trigger_event("transition", true)
		_mouse_clicked = true
		_index = event.index
		set_process_input(true)
