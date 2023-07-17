extends TileMap

@export var cities: Array[City] = []
var tile_size: int = 8

func _ready():
	_create_city_name_labels()
	pass
	
func _process(delta):
	for city in cities:
		city.since_last_production += delta
		if city.since_last_production >= city.production_period:
			city.res_coal += city.producting_coal
			city.res_iron += city.producting_iron
			city.res_workforce += city.producting_workforce
			city.since_last_production = 0
		
		city.since_last_demand += delta
		if city.since_last_demand >= city.demanding_period:
			city.demand_iron += city.demanding_iron
			city.demand_coal += city.demanding_coal
			city.demand_workforce += city.demanding_workforce
			city.since_last_demand = 0
		pass
	
func _input(event):
	if event.is_action_released("click"):
		var pos = get_viewport().canvas_transform.affine_inverse() * (event.position)
		var tile_pos = Vector2(int(pos.x / 8), int(pos.y / 8))
		var clicked_city = search_city(tile_pos)
		if clicked_city != null:
			get_parent().show_city_menu(clicked_city)
			pass

# search a city with a name
func get_city_by_name(name: String) -> City:
	for city in cities:
		if city.name == name: 
			return city
	return null
	pass
	
func search_city(tile_pos): ## search city in cities dictionary from cities list
	for city in cities:
		if city.position == tile_pos:
			return city
	return null
	pass
	
func _create_city_name_labels() -> void:
	for city in cities:
		var label: Label = Label.new()
		label.text = city.name + " - " + str(city.level)
		label.position = Vector2(city.position.x * tile_size - 12, city.position.y * tile_size - 20)
		#label.add_theme_font_size_override("size", 22)
		add_child(label)
	pass
