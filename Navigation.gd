extends Navigation


func _ready():
	yield(get_tree(), "idle_frame")
	print(get_simple_path(Vector3(0, 0, 0.9), Vector3(0, 0, 0.1)))
	print(get_simple_path(Vector3(0, 1, -0.1), Vector3(0, 1, -0.9)))
	print(get_simple_path(Vector3(0, 0, 0.9), Vector3(0, 1, -0.9)))
	print(get_world().direct_space_state.in)
