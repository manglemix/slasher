class_name ProximityAttack
extends SlashAttack


var player: Node


func _ready():
	var scene := get_tree().current_scene
	if scene.player == null:
		yield(scene, "ready")
	player = scene.player


func _physics_process(delta):
	if overlaps_body(player) and not _attacking:
		attack()
