extends Node
class_name time_manager

@export var day_interval: float
const SECONDS_PER_DAY: int = 60 * 60 * 24
var current_date: String
signal update_date

##  start time manager with given date, format: 2023-07-23
func start(init_date: String): 
	current_date = init_date
	$Timer.start(day_interval)
	emit_signal("update_date")

func next_day()->void:
	var a = Time.get_unix_time_from_datetime_string(current_date)
	a += (SECONDS_PER_DAY)
	current_date = Time.get_date_string_from_unix_time(a)
	pass
func _on_timer_timeout():
	next_day()
	$Timer.start(day_interval)
	emit_signal("update_date")
	pass
func _ready():
	start(Time.get_date_string_from_system())
