extends Node2D
## this is the selected city
var _selected_city: City = null: get = get_selected_city, set = set_selected_city
@export_category("General Game Stuff")
@export var game_year: int
@export var game_month: int

@export_category("UI References")
@export var res_coal_label: Label
@export var res_iron_label: Label
@export var res_wf_label: Label
@export var dem_coal_label: Label
@export var dem_iron_label: Label
@export var dem_wf_label: Label
@export var menu_container: VBoxContainer
@export var save_file_dialog: FileDialog

@export_category("Container References")
@export var container_lorry: Node2D

func buy_lorry(modal_name: String, to_location: City) -> void:
	var lorry_scene_path = Catalog.LorryList[modal_name]
	var loaded_lorry_scene = load(lorry_scene_path)
	var lorry_instance = loaded_lorry_scene.instantiate()
	if get_player_resources().get_money() < lorry_instance.cost:
		print("Player does not have enough money to buy")
		lorry_instance.queue_free()
		## TODO add a error message lightbox
		return
	get_player_resources().set_money(get_player_resources().get_money() - lorry_instance.cost)
	lorry_instance.position = Vector2(to_location.position.x * 8 + 4, to_location.position.y * 8 + 4)
	lorry_instance.at_city_name = get_selected_city().name
	container_lorry.add_child(lorry_instance)
	hide_city_menu()
func _process(_delta):
	# update res & demand amounts on screen live
	if $ui_canvas/city_menu.visible:
		res_coal_label.text = str(get_selected_city().res_coal)
		res_iron_label.text = str(get_selected_city().res_iron)
		res_wf_label.text   = str(get_selected_city().res_workforce)
		dem_coal_label.text = str(get_selected_city().demand_coal)
		dem_iron_label.text = str(get_selected_city().demand_iron)
		dem_wf_label.text = str(get_selected_city().demand_workforce)
	pass
## method to show city menu and assign selected city
func show_city_menu(city: City) -> void:
	set_selected_city(city)
	$ui_canvas/city_menu/top_container/lbl_city.text = get_selected_city().name
	$ui_canvas/city_menu.show()
	res_coal_label.text = str(city.res_coal)
	res_iron_label.text = str(city.res_iron)
	res_wf_label.text   = str(city.res_workforce)
	dem_coal_label.text = str(city.demand_coal)
	dem_iron_label.text = str(city.demand_iron)
	dem_wf_label.text = str(city.demand_workforce)
	
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
func _buy_lorry_button_event_handler(lorry_modal: String) -> void:
	buy_lorry(lorry_modal, get_selected_city())
	pass
## get player resources global object
func get_player_resources() -> player_resources:
	return get_tree().root.get_node("game_scene").get_node("player_resources")


func _on_btn_menu_button_up():
	Engine.time_scale = 0
	menu_container.show()
	pass 
func _on_btn_close_m_button_up():
	menu_container.hide()
	Engine.time_scale = 1
	pass 
## function to save game
func _on_btn_save_button_up():
	menu_container.hide()
	save_file_dialog.show()
	pass

## create user://saves folder on first run if not exists
func _on_save_file_dialog_ready():
	DirAccess.make_dir_recursive_absolute("user://saves")
	save_file_dialog.set_root_subfolder("user://saves")
	pass
## write save data to file
func _on_save_file_dialog_file_selected(path):
	print("File selected: " + path)
	Engine.time_scale = 1
	pass # Replace with function body.
