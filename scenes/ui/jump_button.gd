extends Control


var _index: int
var _mouse_clicked := false


func _ready():
	if not OS.has_touchscreen_ui_hint():
		queue_free()
		return
	
	set_process_input(false)


func _input(event):
	if event is InputEventScreenTouch and not event.pressed and event.index == _index:
		_mouse_clicked = false
		set_process_input(false)
		event = InputEventAction.new()
		event.action = "jump"
		event.pressed = false
		Input.parse_input_event(event)


func _gui_input(event):
	if _mouse_clicked:
		return
	
	elif event is InputEventScreenTouch and event.pressed:
		get_tree().set_input_as_handled()
		_mouse_clicked = true
		_index = event.index
		set_process_input(true)
		event = InputEventAction.new()
		event.action = "jump"
		event.pressed = true
		Input.parse_input_event(event)
