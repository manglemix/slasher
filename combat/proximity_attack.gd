class_name ProximityAttack
extends SlashAttack


export var target_path: NodePath = "Player"

var target: Node


func _ready():
	if target_path == NodePath("Player"):
		target = GlobalStuff.yield_and_get_group("Player")[0]
	
	else:
		target = get_node(target_path)


func _physics_process(_delta):
	if overlaps_body(target) and not character_animator.current_animation in anim_names:
		play_slash_anim()
