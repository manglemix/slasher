extends Spatial


func _ready():
	yield(get_tree().create_timer(3), "timeout")
	GlobalStuff.switch_past()
