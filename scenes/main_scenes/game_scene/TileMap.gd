extends TileMap

@export var cities: Array[City] = []
var tile_size: int = 8

func _ready():
	_create_city_name_labels()
	pass
	
func _input(event):
	if event.is_action_released("click"):
		var pos = get_viewport().canvas_transform.affine_inverse() * (event.position)
		var tile_pos = Vector2(int(pos.x / 8), int(pos.y / 8))
		var clicked_city = search_city(tile_pos)
		if clicked_city != null:
			get_parent().show_city_menu(clicked_city)
			pass

func search_city(tile_pos): ## search city in cities dictionary from cities list
	for city in cities:
		if city.position == tile_pos:
			return city
	return null

func _create_city_name_labels() -> void:
	for city in cities:
		var label: Label = Label.new()
		label.text = city.name
		label.position = Vector2(city.position.x * tile_size - 12, city.position.y * tile_size - 20)
		#label.add_theme_font_size_override("size", 22)
		add_child(label)
	pass
