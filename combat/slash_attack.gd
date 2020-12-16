class_name SlashAttack
extends Area


signal attacked

export var max_damage := 5.0
export var min_damage := 1.0
export var animated_sprite_path: NodePath = "../AnimatedSprite"
export var anim_name := "slash"
export var frame_number := 3
export var override_priority := 5
export(Array, NodePath) var audio_paths: Array
export var max_charge_time := 1.0

var attack_delay: float

var _current_charge: float
var _attacking := false

onready var animated_sprite: CharacterAnimator = get_node_or_null(animated_sprite_path)


func _ready():
	set_process(false)
	
	if is_instance_valid(animated_sprite):
		var frames := animated_sprite.frames
		attack_delay = frame_number / frames.get_animation_speed(anim_name)


func charge_attack() -> void:
	set_process(true)


func attack() -> void:
	var damage_points: float = lerp(min_damage, max_damage, _current_charge / max_charge_time)
	_current_charge = 0
	set_process(false)
	
	if _attacking:
		return
	
	_attacking = true
	
	if is_instance_valid(animated_sprite):
		animated_sprite.override_play(anim_name, override_priority)
		yield(get_tree().create_timer(attack_delay), "timeout")
		
		if animated_sprite.animation != anim_name:
			_attacking = false
			return
	
	emit_signal("attacked")
	
	if not audio_paths.empty():
		get_node(audio_paths[int(rand_range(0, audio_paths.size()))]).play()
	
	for body in get_overlapping_bodies():
		if body.has_node("Damageable"):
			body.get_node("Damageable").damage(damage_points)
		
	yield(animated_sprite, "animation_finished")
	_attacking = false


func _process(delta):
	_current_charge += delta
	
	if _current_charge > max_charge_time:
		attack()
