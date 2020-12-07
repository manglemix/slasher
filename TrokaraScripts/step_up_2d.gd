class_name StepUp2D
extends RayCast2D


export var max_step_height := 50.0
export var nudge_weight := 800.0
export var min_nudge_speed := 70.0
export var character_path: NodePath = ".."

var _lerping := false
var _collider: CollisionObject2D

onready var character: Character2D = get_node(character_path)


func _physics_process(delta):
	if _lerping:
		force_raycast_update()
		
		if is_colliding():
			character.global_transform.origin += clamp((cast_to.length() - get_collision_point().distance_to(global_transform.origin)) * nudge_weight * delta, min_nudge_speed, INF) * character.up_vector * delta
		
		else:
			character.remove_collision_exception_with(_collider)
			character.lock_floor = false
			_lerping = false
		
	
	elif character.is_on_wall() and character.is_on_floor():
		force_raycast_update()
		
		if is_colliding():
			var origin := global_transform.origin
			var cast_length := cast_to.length()
			var step_height := cast_length - get_collision_point().distance_to(origin)
			_collider = get_collider()
			if step_height <= max_step_height:
				cast_to *= -1
				force_raycast_update()
				cast_to *= -1
				
				if is_colliding():
					var ceiling_distance := get_collision_point().distance_to(origin)
					if ceiling_distance + step_height < cast_length and not is_equal_approx(ceiling_distance + step_height, cast_length):
						return
				
				character.add_collision_exception_with(_collider)
				character.lock_floor = true
				_lerping = true
