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


func set_max_health(value: float) -> void:
	max_health = value
	if health > max_health:
		health = max_health


func set_health(value: float) -> void:
	if value < health:
		health = value
		emit_signal("damaged", health - value)
		
		if invincible:
			return
	
	elif value > health:
		health = value
		emit_signal("healed", value - health)
		
		if unhealing:
			return
	
	if health > max_health:
		health = max_health
	
	elif health <= 0 and not undying:
		emit_signal("death")


func set_undying(value: bool) -> void:
	undying = value
	
	if not value and health <= 0:
		emit_signal("death")
