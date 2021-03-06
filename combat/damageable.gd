# Adds health functionality to the parent
class_name Damageable
extends Node


signal death
signal healed(value)
signal damaged(value)

export var max_health := 3.0 setget set_max_health
export var health := 3.0 setget set_health
export var invincible := false						# if true, won't take damage
export var undying := false setget set_undying		# if true, won't die when health drops below 0. If health was below 0 and undying is set to false, death will be emitted
export var unhealing := false						# if true, won't be able to heal

var _is_ready := false


func _ready():
	_is_ready = true


func set_max_health(value: float) -> void:
	max_health = value
	
	if health > max_health:
		health = max_health


func set_health(value: float) -> void:
	if not _is_ready:
		health = value
		return
	
	if value < health:
		emit_signal("damaged", health - value)
		
		if invincible:
			return
		
		health = value
		
		if health < 0 and not undying:
			emit_signal("death")
	
	elif value > health:
		emit_signal("healed", value - health)
		
		if unhealing:
			return
		
		health = value
		
		if health > max_health:
			health = max_health


func set_undying(value: bool) -> void:
	undying = value
	
	if not value and health <= 0:
		emit_signal("death")
