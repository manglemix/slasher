extends Area2D


signal attacked

export var animated_sprite_path: NodePath = "../AnimatedSprite"
export var anim_name := "slash"
export var frame_number := 3
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


func slash() -> void:
	_current_charge = 0
	set_process(false)
	
	if _attacking:
		return
	
	_attacking = true
	
	if is_instance_valid(animated_sprite):
		animated_sprite.override_play(anim_name)
		yield(get_tree().create_timer(attack_delay), "timeout")
		
		if animated_sprite.animation != anim_name:
			_attacking = false
			return
	
	emit_signal("attacked")
	
	if not audio_paths.empty():
		get_node(audio_paths[int(rand_range(0, audio_paths.size()))]).play()
	
	for body in get_overlapping_bodies():
		var texture: Texture
		var origin: Vector2
		var full_size: Vector2
		
		if body.has_node("Sprite"):
			texture = body.get_node("Sprite").texture
			full_size = texture.get_size()
			origin = Vector2(0.5, 0.5)
		
		elif body.has_node("AnimatedSprite"):
			var sprite: AnimatedSprite = body.get_node("AnimatedSprite")
			texture = sprite.frames.get_frame(sprite.animation, sprite.frame)
			origin = texture.region.position + texture.region.size / 2
			full_size = texture.atlas.get_size()
			origin = Vector2(origin.x / full_size.x, origin.y / full_size.y)
		
		else:
			continue
		
		var slashed := Slashed.new(texture, tan(deg2rad(rand_range(- 89.99, 89.99))) * full_size.aspect(), origin)
		slashed.parent_children_to_fallers(300)
		get_tree().current_scene.add_child(slashed)
		slashed.global_transform = body.global_transform
		body.queue_free()
		
	yield(animated_sprite, "animation_finished")
	_attacking = false


func _input(event):
	if _current_charge > 0:
		if event.is_action_released("attack"):
			slash()
	
	else:
		if event.is_action_pressed("attack"):
			set_process(true)


func _process(delta):
	_current_charge += delta
	
	if _current_charge > max_charge_time:
		slash()
