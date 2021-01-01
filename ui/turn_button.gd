extends Control


export var glide_time := 0.3

var turn_area: TurnArea

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
		var original_angle: float = GlobalStuff.camera_base.rotation_degrees.y
		var rotations := turn_area.rotations
		
		for i in range(rotations.size()):
			var tmp_diff := rotations[i] - original_angle
			
			if abs(tmp_diff) <= abs(diff):
				diff = tmp_diff
				idx = i
		
		var angle: float
		idx += 1
		
		if idx == rotations.size():
			angle = rotations[0]
		
		else:
			angle = rotations[idx]
		
		var transform := Transform.IDENTITY.rotated(Vector3.UP, deg2rad(angle))
		transform.origin = GlobalStuff.camera_base.global_transform.origin
		var tween := Tween.new()
		tween.interpolate_property(GlobalStuff.camera_base, NodePath("global_transform"), GlobalStuff.camera_base.global_transform, transform, glide_time, Tween.TRANS_QUAD)
		GlobalStuff.camera_base.add_child(tween)
		tween.start()
		
		transform = transform.rotated(Vector3.UP, PI / 2)
		transform.origin = turn_area.global_transform.origin
		tween = Tween.new()
		tween.interpolate_property(GlobalStuff.player, NodePath("global_transform"), GlobalStuff.player.global_transform, transform, glide_time, Tween.TRANS_QUAD)
		GlobalStuff.player.add_child(tween)
		tween.start()
		
		var movement : ControllableCharacterMovement = GlobalStuff.player.get_node("ControllableCharacterMovement")
		movement.targeting = false
		yield(tween, "tween_completed")
		movement.reset_target_basis()
		movement.targeting = true
