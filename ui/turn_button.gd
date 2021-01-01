extends Control


var rotations: PoolRealArray

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
		
		var diff := INF
		var idx: int
		var original_angle: float = GlobalStuff.camera_base.rotation.y
		
		for i in range(rotations.size()):
			var tmp_diff := deg2rad(rotations[i]) - original_angle
			
			if abs(tmp_diff) <= abs(diff):
				diff = tmp_diff
				idx = i
		
		var angle: float
		idx += 1
		
		if idx == rotations.size():
			angle = rotations[0]
		
		else:
			angle = rotations[idx]
		
		GlobalStuff.player.turn_to(deg2rad(angle + 90))
		GlobalStuff.camera_base.rotation_degrees.y = angle
