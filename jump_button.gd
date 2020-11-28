extends TouchScreenButton


var player: Character2D
var player_jump: CharacterJump


func _ready():
	var scene := get_tree().current_scene
	yield(scene, "ready")
	
	player = scene.player
	player_jump = player.get_node("CharacterJump")
	connect("pressed", player_jump, "set_jumping", [true])
	connect("released", player_jump, "set_jumping", [false])
