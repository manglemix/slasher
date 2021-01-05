class_name WormholeSource
extends Spatial


export(Array, PackedScene) var enemy_scenes: Array
export var probabilities: PoolRealArray
export var spawn_time := 10.0


func _ready():
	while true:
		yield(get_tree().create_timer(spawn_time), "timeout")
		spawn_random()


func spawn_random() -> void:
	var random := randf()
	var chance: float
	var i: int
	
	while i < probabilities.size() - 1:
		chance = probabilities[i]
		if random <= chance:
			 break
		i += 1
	
	var enemy: Spatial = enemy_scenes[i].instance()
	get_tree().current_scene.add_child(enemy)
	enemy.global_transform = global_transform
