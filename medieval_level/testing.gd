extends Spatial


onready var player := $ClassicCharacter


func _input(event):
    if event.is_action_pressed("ui_cancel"):
        get_tree().quit()
