extends Spatial


onready var anim = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
    anim.play("Armature001mixamocomLayer0")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
