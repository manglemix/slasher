class_name ControllableAttack
extends SlashAttack


func _input(event):
	if _current_charge > 0:
		if event.is_action_released("attack"):
			play_slash_anim()

	elif event.is_action_pressed("attack"):
		charge_attack()
