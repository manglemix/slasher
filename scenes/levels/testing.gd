extends Node2D


const dummy := preload("res://scenes/soldiers/dummy_king.tscn")

export var spawn_height := 150.0
export var spawn_width := 400.0
export var node_links_path: NodePath = "NodeLinks"


func _ready():
	$DummyKing.connect("tree_exited", self, "add_dummy")
	$DummyKing.get_node("Goto").target = $Protagonist


func add_dummy() -> void:
	var new_dummy = dummy.instance()
	add_child(new_dummy)
	new_dummy.global_transform.origin = Vector2(rand_range(- spawn_width, spawn_width), spawn_height)
	new_dummy.connect("tree_exited", self, "add_dummy")
	new_dummy.get_node("Goto").target = $Protagonist


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
