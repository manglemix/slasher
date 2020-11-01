# A modified pathfinder which constantly checks the path for flags, which will be emitted when reached
class_name FlaggedGoto
extends AStarGoto


signal flag_reached(flag, node)


func _process(_delta):
	update_path()
	
	if not id_path.empty():
		var closest_node: LinkedNode = navigation.get_actual_node(id_path[0])
		var flag: LinkFlag
		
		if id_path.size() > 1:
			# if there are two nodes in the way, check the link between for flags
			flag = closest_node.links[navigation.get_actual_node(id_path[1])]
		
		elif path.size() > 2:
			# if there is only one node in between, check the link from that node to the node in the next segment
			var next_segment := navigation.get_closest_segment(path[2])
			if next_segment[0] == id_path[0]:
				flag = closest_node.links[navigation.get_actual_node(next_segment[1])]
			
			else:
				flag = closest_node.links[navigation.get_actual_node(next_segment[0])]
		
		if is_instance_valid(flag) and \
		navigation.a_star.get_closest_position_in_segment(character.global_transform.origin).distance_to(path[1]) <= flag.distance:
			emit_signal("flag_reached", flag, closest_node)
