extends Camera2D

@export var camera_speed: int = 5
@export var zoom_speed: float = 0.3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("camera_move_left"):
		position.x -= camera_speed
	if Input.is_action_pressed("camera_move_right"):
		position.x += camera_speed
	if Input.is_action_pressed("camera_move_up"):
		position.y -= camera_speed
	if Input.is_action_pressed("camera_move_down"):
		position.y += camera_speed
	pass
func _input(event):
	if event.is_action("camera_zoom_in"):
		if zoom.x < 50:
			zoom.x += (zoom_speed)
			zoom.y = zoom.x
	if event.is_action("camera_zoom_out"):
		if zoom.x > 1.1:
			zoom.x -= (zoom_speed)
			zoom.y = zoom.x
		#print(zoom.x)
