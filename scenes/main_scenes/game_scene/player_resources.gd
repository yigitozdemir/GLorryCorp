extends Node
class_name player_resources

## amount of money player has
var _money: int = 0: get = get_money, set = set_money
## special token is like money but more valuable as problem solver
var _token: int = 0: get = get_token, set = set_token
func get_token() -> int:
	return _token
func set_token(val: int) -> void:
	print("Token updated: " + str(_money))
	_token = val
func get_money() -> int:
	return _money
func set_money(val: int) -> void:
	print("Money updated: " + str(_money))
	_money = val
