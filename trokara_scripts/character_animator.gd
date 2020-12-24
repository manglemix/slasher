class_name CharacterAnimator
extends AnimationPlayer


export var character_jump_path: NodePath

var _override_priority: int

onready var character: Character = get_parent()
onready var character_jump: CharacterJump = get_node(character_jump_path)


func _ready():
	character_jump.connect("jumped", self, "override_play", ["jump-loop"])


func override_play(anim: String, override_priority:=0, restart:=true) -> void:
	if override_priority >= _override_priority:
		_override_priority = override_priority
		set_process(false)
		play(anim)
		
		if restart:
			yield(self, "animation_finished")
			set_process(true)


func _process(_delta):
	if character.is_on_floor():
		if is_zero_approx(character.movement_vector.length_squared()):
			play("idle-loop")
		
		else:
			play("run-loop")
