extends Control


export var max_distance := 100.0
export var return_weight := 20.0

var _index: int
var _mouse_clicked := false


func _ready():
	if not OS.has_touchscreen_ui_hint():
		queue_free()
		return
	
	set_process_input(false)


func _process(delta):
	get_child(0).rect_position *= 1 - return_weight * delta


func _input(event):
	if event is InputEventScreenTouch:
		if not event.pressed and event.index == _index:
			set_process(true)
			set_process_input(false)
			_mouse_clicked = false
			GlobalStuff.trigger_event("move right", false)
			GlobalStuff.trigger_event("move left", false)
			GlobalStuff.trigger_event("move up", false)
			GlobalStuff.trigger_event("move down", false)
		
	elif event is InputEventScreenDrag and event.index == _index:
		var look_vector: Vector2 = (get_canvas_transform().affine_inverse().xform(event.position) - get_global_transform().basis_xform(rect_size) / 2 - rect_global_position).clamped(max_distance)
		var tmp_vector := look_vector / max_distance
		get_child(0).rect_global_position = look_vector + rect_global_position
		
		if tmp_vector.x > 0:
			GlobalStuff.trigger_event("move right", true, tmp_vector.x)
		
		else:
			GlobalStuff.trigger_event("move left", true, - tmp_vector.x)
		
		if tmp_vector.y > 0:
			GlobalStuff.trigger_event("move down", true, tmp_vector.y)
		
		else:
			GlobalStuff.trigger_event("move up", true, - tmp_vector.y)


func _gui_input(event):
	if _mouse_clicked:
		return
	
	elif event is InputEventScreenTouch and event.pressed:
		set_process(false)
		set_process_input(true)
		_mouse_clicked = true
		_index = event.index
		get_tree().set_input_as_handled()
		var look_vector: Vector2 = (event.position - rect_size / 2).clamped(max_distance)
		var tmp_vector := look_vector / max_distance
		get_child(0).rect_position = look_vector
		
		if tmp_vector.x > 0:
			GlobalStuff.trigger_event("move right", true, tmp_vector.x)
		
		else:
			GlobalStuff.trigger_event("move left", true, - tmp_vector.x)
		
		if tmp_vector.y > 0:
			GlobalStuff.trigger_event("move down", true, tmp_vector.y)
		
		else:
			GlobalStuff.trigger_event("move up", true, - tmp_vector.y)
