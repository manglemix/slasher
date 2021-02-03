class_name CharacterAnimator
extends AnimationPlayer


export var character_jump_path: NodePath
export var damageable_path: NodePath
export var blending := 0.2
export var threshold := 1.0
export var walk_anim := "run-loop"
export var idle_anim := "idle-loop"
export var hit_anim := "hit-loop"

var overriding := false
var character_jump: CharacterJump
var damageable: Damageable

var _override_priority: int

onready var character: Character = get_parent()
onready var _last_origin := character.global_transform.origin


func _ready():
	# warning-ignore-all:return_value_discarded
	if not character_jump_path.is_empty():
		character_jump = get_node(character_jump_path)
		character_jump.connect("jumped", self, "play_jump_anim")
	
	if not damageable_path.is_empty():
		damageable = get_node(damageable_path)
		if not hit_anim.empty():
			damageable.connect("damaged", self, "play_hit_anim")


func override_play(anim: String, override_priority:=0) -> void:
	if override_priority >= _override_priority:
		overriding = true
		_override_priority = override_priority
		play(idle_anim)
		play(anim, blending)
		
		yield(self, "animation_finished")
		overriding = false
		_override_priority = 0


func play_hit_anim(_damage) -> void:
	if damageable.health > 0:
		override_play(hit_anim)


func play_jump_anim() -> void:
	if is_zero_approx(character.movement_vector.length_squared()):
		override_play("jump4-loop")
	
	else:
		override_play("jump2-loop")


func _process(delta):
	if character.is_on_floor():
		var new_origin := character.global_transform.origin
		var velocity: Vector3 = (new_origin - _last_origin) / delta
		_last_origin = new_origin
		
		if velocity.length() >= threshold:
			if not overriding:
				play(walk_anim, blending)
			
			get_child(0).play(walk_anim, blending)
		
		else:
			if not overriding:
				play(idle_anim, blending)
			
			get_child(0).play(idle_anim, blending)
	
	get_child(0).advance(delta)
	advance(delta)
