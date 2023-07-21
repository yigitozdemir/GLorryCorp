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
@export var open_file_dialog: FileDialog

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
## create user://saves folder on first run if not exists
func _on_open_file_dialog_ready():
	DirAccess.make_dir_recursive_absolute("user://saves")
	save_file_dialog.set_root_subfolder("user://saves")
	pass
## write save data to file
func _on_save_file_dialog_file_selected(path):
	var save_data = SaveDataModel.new()
	for l in get_node("container_lorry").get_children():
		l = l as Lorry
		var lorry_data: Dictionary = {
			"Modal": l.modal,
			"Brand": l.brand,
			"Model": l.model,
			"Year": l.year,
			"Type": l.type,
			"Capacity": l.capacity,
			"Status": l.status,
			"Speed": l.speed,
			"Cost": l.cost,
			"going_to_city_name": l.going_to_city.name,
			"pos_x": l.position.x,
			"pos_y": l.position.y,
			"nav_pos_x": l.get_node("nav_agent").target_position.x,
			"nav_pos_y": l.get_node("nav_agent").target_position.y,
		}
		save_data.data.lorries.append(lorry_data)
		pass
	for c in $map.cities:
		c = c as City
		var city_data: Dictionary = {
			"name": c.name,
			"position_x": c.position.x,
			"position_y": c.position.y,
			"level": c.level,
			"res_coal": c.res_coal,
			"res_iron": c.res_iron,
			"res_workforce": c.res_workforce,
			"demand_coal": c.demand_coal,
			"demand_iron": c.demand_iron,
			"demand_workforce": c.demand_workforce,
			"producting_coal": c.producting_coal,
			"producting_iron": c.producting_iron,
			"producting_workforce": c.producting_workforce,
			"production_period": c.production_period,
			"since_last_production": c.since_last_production,
			"demanding_coal": c.demanding_coal,
			"demanding_iron": c.demanding_iron,
			"demanding_workforce": c.demanding_workforce,
			"demanding_period": c.demanding_period,
			"since_last_demand": c.since_last_demand
		}
		save_data.data.cities.append(city_data)
		pass
	var fs = FileAccess.open(path, FileAccess.WRITE)
	fs.store_string(str(save_data.data))
	fs.close()
	print(save_data.data)
	Engine.time_scale = 1
	pass # Replace with function body.


func _on_btn_load_button_up():
	menu_container.hide()
	open_file_dialog.show()
	pass # Replace with function body.

## load a save file from file system
func _on_open_file_dialog_file_selected(path):
	var fs = FileAccess.open(path, FileAccess.READ)
	var file_data: String = fs.get_file_as_string(path)
	var data:Dictionary = JSON.parse_string(file_data)
	fs.close()
	for l in $container_lorry.get_children():
		l.queue_free()
	for l in data.lorries:
		var lorry_scene_path = Catalog.LorryList[l.Modal]
		var loaded_lorry_scene = load(lorry_scene_path)
		var lorry_instance = loaded_lorry_scene.instantiate()
		lorry_instance.position.x = l.pos_x
		lorry_instance.position.y = l.pos_y
		lorry_instance.get_node("nav_agent").target_position = Vector2(l.nav_pos_x, l.nav_pos_y)
		lorry_instance.status = l.Status
		lorry_instance.going_to_city = $map.get_city_by_name(l.going_to_city_name)
		$container_lorry.add_child(lorry_instance)
	for c in data.cities:
		var city: City = $map.get_city_by_name(c.name)
		city.position.x = c.position_x
		city.position.y = c.position_y
		city.level = c.level
		city.res_coal = c.res_coal
		city.res_iron = c.res_iron
		city.res_workforce = c.res_workforce
		city.demand_coal = c.demand_coal
		city.demand_iron = c.demand_iron
		city.demand_workforce = c.demand_workforce
		city.producting_coal = c.producting_coal
		city.producting_iron = c.producting_iron
		city.producting_workforce = c.producting_workforce
		city.production_period = c.production_period
		city.since_last_production = c.since_last_production
		city.demanding_coal = c.demanding_coal
		city.demanding_iron = c.demanding_iron
		city.demanding_workforce = c.demanding_workforce
		city.demanding_period = c.demanding_period
		city.since_last_demand = c.since_last_demand
	Engine.time_scale = 1
	pass # Replace with function body.
