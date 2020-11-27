class_name CharacterAnimator
extends AnimatedSprite


export var character_jump_path: NodePath

onready var character: Character2D = get_parent()
onready var character_jump: CharacterJump = get_node(character_jump_path)


func _ready():
	character_jump.connect("jumped", self, "override_play", ["jump"])


func override_play(anim: String, restart:=true) -> void:
	set_process(false)
	play(anim)
	
	if restart:
		yield(self, "animation_finished")
		set_process(true)


func _process(_delta):
	if character.is_on_floor():
		if is_zero_approx(character.movement_vector.length_squared()):
			play("idle")
		
		else:
			play("run")
	
	else:
		play("fall")
