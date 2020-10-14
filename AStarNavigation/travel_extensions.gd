class_name AStarTravelExtensions
extends Node


signal execution_flag(flag, node)

var navigation: AStarNavigation

onready var goto: AStarGoto = get_parent()


func _ready():
	goto.connect("targeted", self, "set_process", [true])
	goto.connect("untargeted", self, "set_process", [false])
	set_process(false)
	
	yield(goto, "ready")
	navigation = goto.navigation


func _process(_delta):
	if not goto.id_path.empty():
		var closest_node: LinkedNode = navigation.get_actual_node(goto.id_path[0])
		for link in closest_node.links:
			var link_info: Array = closest_node.links[link]
			
			if not link_info.empty() and navigation.a_star.get_closest_position_in_segment(goto.character.global_transform.origin).distance_to(goto.path[1]) <= link_info[1]:
				var flag
				if goto.id_path.size() > 1:
					flag = link_info[0]
				
				else:
					var end_segment := navigation.get_closest_segment(goto.path[-1])
					if link.id in end_segment:
						flag = link_info[0]
				
				if flag != null:
					emit_signal("execution_flag", flag, closest_node)
