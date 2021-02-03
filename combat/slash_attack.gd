class_name SlashAttack
extends Area


signal attacked

export var max_damage := 5.0
export var min_damage := 1.0
export var character_animator_path: NodePath = "../CharacterAnimator"
export var anim_names := PoolStringArray(["slash-loop"])
export var max_charge_time := 1.0
export var override_priority := 5

var _current_charge: float

onready var character_animator: CharacterAnimator = get_node_or_null(character_animator_path)


func attack() -> void:
	var damage_points: float = lerp(min_damage, max_damage, _current_charge / max_charge_time)
	
	for body in get_overlapping_bodies():
		if body != get_parent() and body.has_node("Damageable"):
			body.get_node("Damageable").health -= damage_points
	
	emit_signal("attacked")


func _ready():
	set_process(false)


func charge_attack() -> void:
	_current_charge = 0
	set_process(true)


func play_slash_anim() -> void:
	character_animator.override_play(anim_names[int(rand_range(0, anim_names.size()))], override_priority)
	set_process(false)


func _process(delta):
	_current_charge += delta
	
	if _current_charge > max_charge_time:
		play_slash_anim()
