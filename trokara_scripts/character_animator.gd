class_name CharacterAnimator
extends AnimationPlayer


export var character_jump_path: NodePath
export var blending := 0.2

var overriding := false

var _override_priority: int

onready var character: Character = get_parent()
onready var character_jump: CharacterJump = get_node(character_jump_path)


func _ready():
	# warning-ignore:return_value_discarded
	character_jump.connect("jumped", self, "play_jump_anim")


func override_play(anim: String, override_priority:=0) -> void:
	if override_priority >= _override_priority:
		overriding = true
		_override_priority = override_priority
		play("idle-loop")
		play(anim, blending)
		
		yield(self, "animation_finished")
		overriding = false
		_override_priority = 0


func play_jump_anim() -> void:
	if is_zero_approx(character.movement_vector.length_squared()):
		override_play("jump4-loop")
	
	else:
		override_play("jump2-loop")


func _process(_delta):
	if character.is_on_floor():
		if is_zero_approx(character.movement_vector.length_squared()):
			if not overriding:
				play("idle-loop", blending)
			
			get_child(0).play("idle-loop", blending)
		
		else:
			if not overriding:
				play("run-loop", blending)
			
			get_child(0).play("run-loop", blending)
