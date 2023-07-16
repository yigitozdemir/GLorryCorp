extends Node2D
class_name Lorry
## nav_agent refers to the navigation agent a lorry contains
@onready var nav_agent: NavigationAgent2D = get_node("nav_agent")
## TileMap of the game
@onready var map: TileMap = _get_tilemap()

enum TruckStatus {
	Idle,
	Loading,
	CalculatingDemand,
	Moving,
	Dumping
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

@export_category("Containing resources")
@export var con_coal: int
@export var con_iron: int
@export var con_workforce: int

@export_category("Location information")
@export var at_city_name: String

var finish_pos = Vector2(558, 188)

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

## idle -> loading -> CalculatingDemand -> moving -> dumping -> idle
## states will switch in this circles
func _process(_delta):
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
	pass
	
func _dump_containement_data():
	print("con coal: " + str(con_coal))
	print("con iron: " + str(con_iron))
	print("con wf: "   + str(con_workforce))
## returns the TileMap used in this game
func _get_tilemap() -> TileMap:
	return get_tree().root.get_node("game_scene").get_node("map")
