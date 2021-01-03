extends Spatial


export var player_path: NodePath = "ClassicCharacter"
export var camera_base_path: NodePath = "Lerper"


func _ready():
    GlobalStuff.player = get_node(player_path)
    GlobalStuff.camera_base = get_node(camera_base_path)
    $bot/AStarGoto.target = $ClassicCharacter


func _input(event):
    if event.is_action_pressed("ui_cancel"):
        get_tree().quit()
