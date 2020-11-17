class_name Damageable
extends Node


signal death

export var health := 2.0
export var min_health := 1.0
export var armour := 1.0
export var texture_source_path: NodePath = "../AnimatedSprite"
export var hit_anim := "hit"
export var character_movement_path: NodePath

var character_movement: CharacterMovement2D

onready var texture_source: Node = get_node(texture_source_path)


func _ready():
	if not character_movement_path.is_empty():
		character_movement = get_node(character_movement_path)


func damage(hit_points: float) -> void:
	hit_points /= armour
	
	if hit_points >= health:
		slash()
		emit_signal("death")
		get_parent().queue_free()
	
	else:
		if texture_source.has_method("override_play"):
			texture_source.override_play(hit_anim)
		
		health = clamp(health - hit_points / armour, min_health, INF)
		
		if is_instance_valid(character_movement) and texture_source.has_method("override_play"):
			character_movement.set_process(false)
			character_movement.character.movement_vector = Vector2.ZERO
			yield(texture_source, "animation_finished")
			character_movement.set_process(true)


func slash() -> void:
	var texture: Texture
	var origin: Vector2
	var full_size: Vector2
	
	if texture_source is Sprite:
		texture = texture_source.texture
		full_size = texture.get_size()
		origin = Vector2(0.5, 0.5)
	
	elif texture_source is AnimatedSprite:
		texture = texture_source.frames.get_frame(texture_source.animation, texture_source.frame)
		full_size = texture.region.size
		var grid: Vector2 = texture.atlas.get_size()
		grid.x /= full_size.x
		grid.y /= full_size.y
		origin = Vector2(
			(texture_source.frame % int(grid.x)) / grid.x + 1.0 / 2 / grid.x,
			floor(texture_source.frame / grid.x) / grid.y + 1.0 / 2 / grid.y
		)
	
	else:
		push_error(str(texture_source) + " is an unrecognised texture source")
	
	var slashed := Slashed.new(texture, tan(deg2rad(rand_range(- 89.99, 89.99))) * full_size.aspect(), origin)
	slashed.parent_children_to_fallers(300)
	get_tree().current_scene.add_child(slashed)
	slashed.global_transform = texture_source.global_transform
