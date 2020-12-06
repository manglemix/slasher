extends Control


export var max_distance := 100.0
export var return_weight := 20.0

var player_movement: CharacterMovement2D

var _index: int
var _mouse_clicked := false


func _ready():
	if not OS.has_touchscreen_ui_hint():
		queue_free()
		return
	
	set_process_input(false)
	var scene := get_tree().current_scene
	if scene.player == null:
		yield(scene, "ready")
	player_movement = scene.player.get_node("ControllableCharacterMovement2D")


func _process(delta):
	get_child(0).rect_position *= 1 - return_weight * delta


func _input(event):
	if event is InputEventScreenTouch:
		if not event.pressed and event.index == _index:
			set_process(true)
			set_process_input(false)
			_mouse_clicked = false
			player_movement.movement_vector = Vector2.ZERO
		
	elif event is InputEventScreenDrag and event.index == _index:
		var look_vector: Vector2 = (get_canvas_transform().affine_inverse().xform(event.position) - get_global_transform().basis_xform(rect_size) / 2 - rect_global_position).clamped(max_distance)
		player_movement.movement_vector = look_vector / max_distance
		get_child(0).rect_global_position = look_vector + rect_global_position


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
		player_movement.movement_vector = look_vector / max_distance
		get_child(0).rect_position = look_vector
