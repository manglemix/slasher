class_name ZoomableCamera2D
extends MobileCamera


export var min_scale := 0.5
export var max_scale := 2.0
export var scale_step := 0.075
export var weight := 10.0

onready var zoom_scale := (zoom.x + zoom.y) / 2


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP:
			zoom_scale = clamp(zoom_scale - scale_step, min_scale, max_scale)
		
		elif event.button_index == BUTTON_WHEEL_DOWN:
			zoom_scale = clamp(zoom_scale + scale_step, min_scale, max_scale)


func _process(delta):
		zoom = zoom.linear_interpolate(Vector2.ONE * zoom_scale, weight * delta)
