extends Node2D
## this is the selected city
var _selected_city: City = null: get = get_selected_city, set = set_selected_city

## method to show city menu and assign selected city
func show_city_menu(city: City) -> void:
	set_selected_city(city)
	$ui_canvas/city_menu/top_container/lbl_city.text = get_selected_city().name
	$ui_canvas/city_menu.show()
## method to hide city menu and clear selected city
func hide_city_menu() -> void:
	$ui_canvas/city_menu.hide()
	set_selected_city(null)
	
func get_selected_city()->City:
	return _selected_city
func set_selected_city(_val : City)->void:
	_selected_city = _val

## event called when $city_menu/top_container/btn_close is clicked
func _on_btn_close_button_up():
	hide_city_menu()
	pass # Replace with function body.