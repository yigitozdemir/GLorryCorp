extends Node
class_name ledger
## {date: date, amount: 5, ie: i}
## {date: date, amount: 5, ie: e}
@export var _data: Array[Dictionary] = []: get = get_data, set = set_data

## add new accounting data to existing entries
func add_entry(new_entry) -> void:
	#print("New Entry: " + str (new_entry))
	_data.append(new_entry)
	pass
func get_data() -> Array:
	return _data
func set_data(d: Array) -> void:
	_data = d
