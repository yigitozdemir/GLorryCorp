extends Node2D
class_name Lorry
## nav_agent refers to the navigation agent a lorry contains
@onready var nav_agent: NavigationAgent2D = get_node("nav_agent")
## TileMap of the game
@onready var map: TileMap = _get_tilemap()
## if mouse hovers the object
var mouse_hover: bool = false

enum TruckStatus {
	Idle,
	Loading,
	CalculatingDemand,
	Moving,
	Dumping,
	Broken
}

enum ResourceType {
	None,
	Coal,
	Iron,
	Workforce
}

@export_category("Lorry properties")
@export var modal: String
@export var brand: String
@export var model: String
@export var year: int
@export var type: int
@export var capacity: int
@export var status: TruckStatus = TruckStatus.Idle
@export var speed: float = 2
@export var cost: int = 100
@export var total_kilometers: float = 0

@export_category("Errors")
## car breakdown possibility on each frame
@export var breakdown_possibility = 0.1

@export_category("Containing resources")
@export var con_coal: int
@export var con_iron: int
@export var con_workforce: int

@export_category("Location information")
@export var at_city_name: String
@export var going_to_city: City ## the city lorry headed for
@export var destination_distance: float ## distance between lorry and destination

@export_category("Monetary")
@export var cost_per_distance: float = 1.0 ## pay per distance unit

var finish_pos = Vector2(558, 188)
@onready var random: RandomNumberGenerator = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Lorry initiated")
	#print(nav_agent.get_navigation_map())
	nav_agent.set_navigation_map(_get_tilemap().get_navigation_map(0))
	#print(nav_agent.get_navigation_map())
	NavigationServer2D.map_force_update(nav_agent.get_navigation_map())
	NavigationServer2D.map_set_active(nav_agent.get_navigation_map(), true)
	pass

func arrive(to_city: City) -> void: 
	to_city.res_coal += con_coal
	to_city.res_iron += con_iron
	to_city.res_workforce += con_workforce
	pass

func set_target(target_position: Vector2) -> void:
	nav_agent.target_position = finish_pos
	nav_agent.get_next_path_position()
	#print(nav_agent.get_next_path_position())
	#print("Target Reachable: " + str(nav_agent.is_target_reachable()))
	
	var asd = nav_agent.get_current_navigation_path()
	for c in asd:
		print(c)
	pass


## idle -> loading -> CalculatingDemand -> moving (-> broken ->) -> dumping -> idle
## states will switch in this circles
func _process(delta):
	#nav_agent.get_next_path_position()
	#print(nav_agent.get_next_path_position())
	#print("Target Reachable: " + str(nav_agent.is_target_reachable()))
	if status == TruckStatus.Idle:
		var current_city: City = map.get_city_by_name(at_city_name)
		if current_city.res_coal > 0 \
		or current_city.res_iron > 0:
			status = TruckStatus.Loading
	
	if status == TruckStatus.Loading:
		var current_city: City = map.get_city_by_name(at_city_name)
		var selected_res_type: ResourceType = ResourceType.None
		
		if current_city.res_coal >= current_city.res_iron \
		and current_city.res_coal >= current_city.res_workforce:
			selected_res_type = ResourceType.Coal
		
		if current_city.res_iron >= current_city.res_coal \
		and current_city.res_iron >= current_city.res_workforce:
			selected_res_type = ResourceType.Iron
		
		if current_city.res_workforce >= current_city.res_iron \
		and current_city.res_workforce >= current_city.res_coal:
			selected_res_type = ResourceType.Workforce
		
		if selected_res_type == ResourceType.Iron:
			if current_city.res_iron >= capacity:
				current_city.res_iron -= capacity
				con_iron += capacity
			else:
				con_iron += current_city.res_iron
				current_city.res_iron = 0
		if selected_res_type == ResourceType.Coal:
			if current_city.res_coal >= capacity:
				current_city.res_coal -= capacity
				con_coal += capacity
			else:
				con_coal += current_city.res_coal
				current_city.res_coal = 0
		if selected_res_type == ResourceType.Workforce:
			if current_city.res_workforce >= capacity:
				current_city.res_workforce -= capacity
				con_workforce += capacity
			else:
				con_workforce += current_city.res_workforce
				current_city.res_workforce = 0
		
		if selected_res_type == ResourceType.None:
			# skip if no resources selected to move
			return
		else:
			_dump_containement_data()
			status = TruckStatus.CalculatingDemand
			
		#decide load
		pass
	
	if status == TruckStatus.CalculatingDemand:
		for city in map.cities:
			if city.name != at_city_name:
				if con_coal > 0 and city.demand_coal > 0:
					going_to_city = city
					status = TruckStatus.Moving
					print("target is : " + city.name + " containing coal")
					nav_agent.target_position = Vector2(going_to_city.position.x * 8 + 4, going_to_city.position.y * 8 + 4)
					destination_distance = nav_agent.distance_to_target()
					return
				if con_iron > 0 and city.demand_iron > 0:
					going_to_city = city
					status = TruckStatus.Moving
					print("target is : " + city.name + " containing iron")
					nav_agent.target_position = Vector2(going_to_city.position.x * 8 + 4, going_to_city.position.y * 8 + 4)
					destination_distance = nav_agent.distance_to_target()
					return
				if con_workforce > 0 and city.demand_workforce:
					going_to_city = city
					status = TruckStatus.Moving
					print("target is : " + city.name + " containing workforce")
					nav_agent.target_position = Vector2(going_to_city.position.x * 8 + 4, going_to_city.position.y * 8 + 4)
					destination_distance = nav_agent.distance_to_target()
					return
			pass
		pass
	
	if status == TruckStatus.Moving:
		nav_agent.target_position = Vector2(going_to_city.position.x * 8 + 4, going_to_city.position.y * 8 + 4)
		nav_agent.get_next_path_position()
		var new_velocity: Vector2 = (nav_agent.get_next_path_position() - position).normalized() * speed * delta
		look_at(nav_agent.get_next_path_position())
		nav_agent.set_velocity(new_velocity)
		_on_nav_agent_velocity_computed(new_velocity)
		
		var rnd = random.randf()
		if rnd < breakdown_possibility:
			status = TruckStatus.Broken
			print("this is broken")
	
	if status == TruckStatus.Broken:
		pass
	
	if status == TruckStatus.Dumping:
		going_to_city.demand_coal -= con_coal
		going_to_city.demand_iron -= con_iron
		going_to_city.demand_workforce -= con_workforce
		
		total_kilometers += destination_distance
		
		get_player_resources().set_money(get_player_resources().get_money() + (destination_distance * cost_per_distance))
		con_coal = 0
		con_iron = 0
		con_workforce = 0
		
		at_city_name = going_to_city.name
		
		status = TruckStatus.Idle
	
	
	pass
	
func _dump_containement_data():
	print("con coal: " + str(con_coal))
	print("con iron: " + str(con_iron))
	print("con wf: "   + str(con_workforce))
## returns the TileMap used in this game
func _get_tilemap() -> TileMap:
	return get_tree().root.get_node("game_scene").get_node("map")


func _on_nav_agent_velocity_computed(safe_velocity):
	#print("event is calling")
	global_position = global_position.move_toward(global_position + safe_velocity, speed)
	pass # Replace with function body.


func _on_nav_agent_navigation_finished():
	status = TruckStatus.Dumping
	pass # Replace with function body.

## get player resources global object
func get_player_resources() -> player_resources:
	return get_tree().root.get_node("game_scene").get_node("player_resources")


func _on_area_mouse_entered():
	mouse_hover = true
	pass 
func _on_area_mouse_exited():
	mouse_hover = false
	pass 

func _on_area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_released():
			set_selected_lorry()
			#print("clicked to lorry")
	pass

func set_selected_lorry():
	get_tree().root.get_node("game_scene").set_selected_lorry(self)
	get_tree().root.get_node("game_scene").show_lorry_menu()
	pass
