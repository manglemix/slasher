class_name Slashed
extends Node2D


const slice_shader: Shader = preload("res://slicer.shader")

var half1 := Sprite.new()
var half2 := Sprite.new()

var _gradient_sign: float
var _exits: int


func _init(texture: Texture, gradient:=0.0, origin:=Vector2(0.5, 0.5)):
	half1.texture = texture
	half2.texture = texture
	
	var shader_material := ShaderMaterial.new()
	shader_material.shader = slice_shader
	shader_material.set_shader_param("gradient", gradient)
	shader_material.set_shader_param("origin", origin)
	shader_material.set_shader_param("texture", texture)
	half1.material = shader_material

	shader_material = shader_material.duplicate()
	shader_material.set_shader_param("invert", true)
	half2.material = shader_material
	
	_gradient_sign = sign(gradient)


func _ready():
	half1.connect("tree_exited", self, "_increment_exits")
	half2.connect("tree_exited", self, "_increment_exits")


func parent_children(half1_parent: Node, half2_parent: Node) -> void:
	half1_parent.add_child(half1)
	half2_parent.add_child(half2)


func parent_children_to_self() -> void:
	parent_children(self, self)


func parent_children_to_fallers(initial_speed:=0.0, top_cone_angle:=PI/4) -> void:
	var faller1 := BasicFaller.new()
	var faller2 := BasicFaller.new()
	faller1.linear_velocity = - faller1.down_vector.rotated(rand_range(0, top_cone_angle) * _gradient_sign) * initial_speed
	faller2.linear_velocity = - faller1.down_vector.rotated(- rand_range(0, top_cone_angle) * _gradient_sign) * initial_speed
	parent_children(faller1, faller2)
	add_child(faller1)
	add_child(faller2)


func _increment_exits() -> void:
	_exits += 1
	
	if _exits == 2:
		queue_free()
