extends Node
class_name player_resources
@export_category("UI Exports")
@export var money_val_label: Label
@export var token_val_label: Label

enum ChangeType {
	Income=1,
	Expense=2
}

## amount of money player has
var _money: int = 0: get = get_money, set = set_money
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
	var ct: ChangeType
	var amount: int
	var date: String
	if _money < val:
		ct = ChangeType.Income
		amount = val - get_money()
		date = get_time_manager().current_date
	else:
		ct = ChangeType.Expense
		amount = val - get_money()
		date = get_time_manager().current_date
	update_ledger(date, amount, ct)
	_money = val
	print("Money updated: " + str(_money))
	money_val_label.text = str(_money)
func _ready():
	set_money(100)
## adds the new entry to ledger
func update_ledger(date: String, amount: int, change: ChangeType)->void:
	get_ledger().add_entry({"date": date, "amount": amount, "ie": change})
	pass
## get ledger of the game
func get_ledger() -> ledger:
	return get_tree().root.get_node("game_scene/ledger")
func get_time_manager() -> time_manager:
	return get_tree().root.get_node("game_scene/time_manager")
