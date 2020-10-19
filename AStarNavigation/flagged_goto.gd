class_name FlaggedGoto
extends AStarGoto


signal execution_flag(flag, node)


func _process(_delta):
	update_path()
	
	if not id_path.empty():
		var closest_node: LinkedNode = navigation.get_actual_node(id_path[0])
		for link in closest_node.links:
			var link_info: Array = closest_node.links[link]
			
			if not link_info.empty() and navigation.a_star.get_closest_position_in_segment(character.global_transform.origin).distance_to(path[1]) <= link_info[1]:
				var flag
				if id_path.size() > 1:
					flag = link_info[0]
				
				else:
					var end_segment := navigation.get_closest_segment(path[-1])
					if link.id in end_segment:
						flag = link_info[0]
				
				if flag != null:
					emit_signal("execution_flag", flag, closest_node)
