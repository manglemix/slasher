extends Control


export var rotation_delay := 1.0
export var max_distance := 100.0

var player_movement: CharacterMovement2D
var player_attack: SlashAttack

var _index: int
var _timer: float


func _ready():
	set_process_input(false)
	set_process(false)
	hide()
	
	var scene := get_tree().current_scene
	if scene.player == null:
		yield(scene, "ready")
	var player = scene.player
	player_movement = player.get_node("ControllableCharacterMovement2D")
	player_attack = player.get_node("ControllableSlashAttack")


func _input(event):
	if (event is InputEventMouseButton and event.button_index == BUTTON_LEFT) or (event is InputEventScreenTouch and event.index == _index):
		if not event.pressed:
			set_process_input(false)
			set_process_unhandled_input(true)
			hide()
			get_tree().set_input_as_handled()
			event = InputEventAction.new()
			event.action = "attack"
			event.pressed = false
			Input.parse_input_event(event)
			_timer = rotation_delay
			set_process(true)
	
	elif event is InputEventMouseMotion or (event is InputEventScreenDrag and event.index == _index):
		player_movement.auto_rotate = true
		var child: Control = get_child(0)
		var look_vector: Vector2 = get_canvas_transform().affine_inverse().xform(event.position) - rect_global_position - child.get_global_transform().basis_xform(child.rect_size) / 2
		child.rect_global_position = look_vector.clamped(max_distance) + rect_global_position
		player_movement.target_origin = player_movement.character.global_transform.origin + look_vector


func _unhandled_input(event):
	if ((event is InputEventMouseButton and event.button_index == BUTTON_LEFT) or (event is InputEventScreenTouch)) and event.pressed:
		get_tree().set_input_as_handled()
		set_process(false)
		set_process_input(true)
		set_process_unhandled_input(false)
		if event is InputEventScreenTouch:
			_index = event.index
		rect_global_position = get_canvas_transform().affine_inverse().xform(event.position) - get_global_transform().basis_xform(rect_size) / 2
		get_child(0).rect_position = Vector2.ZERO
		show()
		player_movement.rotation_style = CharacterMovement2D.RotationStyles.FACE_ORIGIN
		player_movement.rotate_once = true
		event = InputEventAction.new()
		event.action = "attack"
		event.pressed = true
		Input.parse_input_event(event)


func _process(delta):
	_timer -= delta
	if _timer <= 0:
		set_process(false)
		player_movement.rotation_style = CharacterMovement2D.RotationStyles.FACE_MOVEMENT
		player_movement.rotate_once = false
		player_movement.auto_rotate = true
