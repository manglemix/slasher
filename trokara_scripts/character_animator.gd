class_name CharacterAnimator
extends AnimationPlayer


export var character_jump_path: NodePath
export var blending := 0.2

var _override_priority: int

onready var character: Character = get_parent()
onready var character_jump: CharacterJump = get_node(character_jump_path)


func _ready():
	character_jump.connect("jumped", self, "play_jump_anim")


func override_play(anim: String, override_priority:=0, restart:=true) -> void:
	if override_priority >= _override_priority:
		_override_priority = override_priority
		set_process(false)
		play("idle-loop")
		play(anim, blending)
		
		if restart:
			yield(self, "animation_finished")
			_override_priority = 0
			set_process(true)


func play_jump_anim() -> void:
	if is_zero_approx(character.movement_vector.length_squared()):
		override_play("jump4-loop")
	
	else:
		override_play("jump2-loop")


func _process(_delta):
	if character.is_on_floor():
		if is_zero_approx(character.movement_vector.length_squared()):
			play("idle-loop", blending)
		
		else:
			play("run-loop", blending)
