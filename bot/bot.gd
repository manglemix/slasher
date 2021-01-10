extends ClassicCharacter


func _ready():
    $AStarGoto.target = GlobalStuff.player
