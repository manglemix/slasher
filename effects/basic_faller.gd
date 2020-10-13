class_name BasicFaller
extends Node2D


export var death_timer := 2.0

var gravity_factor := 1.0
var linear_velocity: Vector2
var down_vector: Vector2 = ProjectSettings.get_setting("physics/2d/default_gravity_vector")
var gravity_acceleration: float = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	yield(get_tree().create_timer(death_timer), "timeout")
	queue_free()


func _physics_process(delta):
	linear_velocity += down_vector * gravity_acceleration * gravity_factor * delta
	global_transform.origin += linear_velocity * delta
