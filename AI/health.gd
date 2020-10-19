class_name Health
extends Node


export var health := 2.0
export var min_health := 1.0
export var armour := 1.0


func damage(hit_points: float) -> void:
	hit_points /= armour
	
	if hit_points > min_health:
		slash()
	
	else:
		health = clamp(health - hit_points / armour, min_health, INF)


func slash() -> void:
	
