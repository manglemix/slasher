extends Control


export var rotation_delay := 1.0
export var max_distance := 100.0

var player: Character
var face_movement: FaceMovement
var player_attack: ControllableAttack

var _index: int
var _charge_time_msecs: int


func _ready():
	set_process_input(false)
	set_process(false)
	hide()
	
	player = GlobalStuff.yield_and_get_group("Player")[0]
	face_movement = player.get_node("FaceMovement")
	player_attack = player.get_node("ControllableAttack")


func _input(event):
	# warning-ignore-all:return_value_discarded
	if (event is InputEventMouseButton and event.button_index == BUTTON_LEFT) or (event is InputEventScreenTouch and event.index == _index):
		if not event.pressed:
			get_tree().set_input_as_handled()
			set_process_input(false)
			set_process_unhandled_input(true)
			hide()
			
			GlobalStuff.trigger_event("attack", false)
			
			if (OS.get_system_time_msecs() - _charge_time_msecs) / 1000.0 <= player_attack.max_charge_time:
				yield(player_attack.character_animator, "animation_finished")
			
			face_movement.enabled = true
	
	elif event is InputEventMouseMotion or (event is InputEventScreenDrag and event.index == _index):
		var child: Control = get_child(0)
		var tmp_vector: Vector2 = get_canvas_transform().affine_inverse().xform(event.position) - rect_global_position - child.get_global_transform().basis_xform(child.rect_size) / 2
		child.rect_global_position = tmp_vector.clamped(max_distance) + rect_global_position
		face_movement.input_vector = get_viewport().get_camera().global_transform.basis.xform(Vector3(tmp_vector.x, 0, tmp_vector.y))


func _unhandled_input(event):
	# warning-ignore-all:return_value_discarded
	if ((event is InputEventMouseButton and event.button_index == BUTTON_LEFT) or (event is InputEventScreenTouch)) and event.pressed:
		get_tree().set_input_as_handled()
		set_process(false)
		set_process_input(true)
		set_process_unhandled_input(false)
		
		if event is InputEventScreenTouch:
			_index = event.index
		
		rect_global_position = get_canvas_transform().affine_inverse().xform(event.position) - get_global_transform().basis_xform(rect_size) / 2
		get_child(0).rect_position = Vector2.ZERO
		face_movement.enabled = false
		show()
		
		GlobalStuff.trigger_event("attack", true)
		_charge_time_msecs = OS.get_system_time_msecs()
