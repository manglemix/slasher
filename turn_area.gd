class_name TurnArea
extends Area


export var glide_time := 0.3
export var rotations: PoolRealArray


func _ready():
	# warning-ignore-all:return_value_discarded
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
	# warning-ignore-all:return_value_discarded
	if event.is_action_pressed("transition"):
		var diff := INF
		var idx: int
		var original_angle: float = GlobalStuff.camera_base.rotation_degrees.y
		
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
		
		var new_transform := Transform.IDENTITY.rotated(Vector3.UP, deg2rad(angle))
		new_transform.origin = GlobalStuff.camera_base.global_transform.origin
		var tween := Tween.new()
		tween.interpolate_property(GlobalStuff.camera_base, NodePath("global_transform"), GlobalStuff.camera_base.global_transform, new_transform, glide_time, Tween.TRANS_QUAD)
		GlobalStuff.camera_base.add_child(tween)
		tween.start()
		
		new_transform = new_transform.rotated(Vector3.UP, PI / 2)
		new_transform.origin = global_transform.origin
		tween = Tween.new()
		tween.interpolate_property(GlobalStuff.player, NodePath("global_transform"), GlobalStuff.player.global_transform, new_transform, glide_time, Tween.TRANS_QUAD)
		GlobalStuff.player.add_child(tween)
		tween.start()
		
		var movement: FaceMovement = GlobalStuff.player.get_node("FaceMovement")
		movement.enabled = false
		yield(tween, "tween_completed")
		movement.enabled = true
