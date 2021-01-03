class_name SlashAttack
extends Area


signal attacked

export var max_damage := 5.0
export var min_damage := 1.0
export var character_animator_path: NodePath = "../CharacterAnimator"
export var anim_name := "slash"
export var attack_delay := 1.0
export var override_priority := 5
export(Array, NodePath) var audio_paths: Array
export var max_charge_time := 1.0

var _current_charge: float
var _attacking := false

onready var character_animator: CharacterAnimator = get_node_or_null(character_animator_path)


func _ready():
	set_process(false)


func charge_attack() -> void:
	set_process(true)


func attack() -> void:
	var damage_points: float = lerp(min_damage, max_damage, _current_charge / max_charge_time)
	_current_charge = 0
	set_process(false)
	
	if _attacking:
		return
	
	_attacking = true
	
	if is_instance_valid(character_animator):
		character_animator.override_play(anim_name, override_priority)
		yield(get_tree().create_timer(attack_delay), "timeout")
		
		if character_animator.current_animation != anim_name:
			_attacking = false
			return
	
	emit_signal("attacked")
	
	if not audio_paths.empty():
		get_node(audio_paths[int(rand_range(0, audio_paths.size()))]).play()
	
	for body in get_overlapping_bodies():
		if body.has_node("Damageable"):
			body.get_node("Damageable").damage(damage_points)
		
	yield(character_animator, "animation_finished")
	_attacking = false


func _process(delta):
	_current_charge += delta
	
	if _current_charge > max_charge_time:
		attack()
