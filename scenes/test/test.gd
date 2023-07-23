extends Node2D

const SECONDS_PER_DAY: int = 60 * 60 * 24

# Called when the node enters the scene tree for the first time.
func _ready():
	print(Time.get_date_string_from_system(false))
	var a = Time.get_unix_time_from_datetime_string(Time.get_date_string_from_system(false))
	a += (SECONDS_PER_DAY * 9)
	print(Time.get_date_string_from_unix_time(a))
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
