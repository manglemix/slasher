class_name Background
extends Panel


func _enter_tree():
	var scene := get_tree().current_scene
	if get_parent() != scene:
		get_parent().call_deferred("remove_child", self)
		yield(self, "tree_exited")
		scene.call_deferred("add_child", self)
		scene.call_deferred("move_child", self, 0)
