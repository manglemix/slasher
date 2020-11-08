# This script should be used by Area (2D and 3D), to cause the bodies inside to jump
class_name JumpZone
extends PathTrigger2D


export var jump_node_name := "CharacterJump"
export var jump_time := INF
export var max_angle_to_next_degrees := 360.0 setget set_max_angle_to_next_degrees

var max_angle_to_next: float = TAU setget set_max_angle_to_next


func set_max_angle_to_next(value: float) -> void:
	max_angle_to_next_degrees = rad2deg(value)
	max_angle_to_next = value


func set_max_angle_to_next_degrees(value: float) -> void:
	max_angle_to_next_degrees = value
	max_angle_to_next = deg2rad(value)


func _ready():
	set_constant_update(true)


func _check_body(body: Node) -> void:
	var goto: AStarGoto = body.get_node_or_null(goto_name)
	if is_instance_valid(goto) and not goto.id_path.empty() and (goto.id_path[0] == linked_node.id or (goto.id_path.size() > 1 and goto.id_path[0] == get_parent().id and goto.id_path[1] == linked_node.id)):
		if goto.id_path[0] == get_parent().id:
			if abs(goto.get_parent().linear_velocity.angle_to(goto.path[2] - goto.path[1])) <= max_angle_to_next:
				_triggered(body)
		
		else:
			if abs(goto.get_parent().linear_velocity.angle_to(goto.path[1] - goto.path[0])) <= max_angle_to_next:
				_triggered(body)


func _triggered(body: Node) -> void:
	var node: CharacterJump = body.get_node_or_null(jump_node_name)
	if is_instance_valid(node):
		node.jumping = true
		if not is_inf(jump_time):
			yield(get_tree().create_timer(jump_time), "timeout")
			node.jumping = false
