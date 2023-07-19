extends Node
class_name player_resources
@export_category("UI Exports")
@export var money_val_label: Label
@export var token_val_label: Label

## amount of money player has
var _money: int = 100: get = get_money, set = set_money
## special token is like money but more valuable as problem solver
var _token: int = 5: get = get_token, set = set_token
func get_token() -> int:
	return _token
func set_token(val: int) -> void:
	_token = val
	print("Token updated: " + str(_money))
	token_val_label.text = str(token_val_label)
func get_money() -> int:
	return _money
func set_money(val: int) -> void:
	_money = val
	print("Money updated: " + str(_money))
	money_val_label.text = str(_money)
