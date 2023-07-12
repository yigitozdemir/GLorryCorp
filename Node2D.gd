extends Node2D

@onready var nav_agent: NavigationAgent2D = get_node("NavigationAgent2D")
var finish_pos = Vector2(558, 188)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	print(nav_agent.get_navigation_map())
	nav_agent.set_navigation_map(((get_parent().get_node("TileMap"))as TileMap).get_navigation_map(0))
	print(nav_agent.get_navigation_map())
	NavigationServer2D.map_force_update(nav_agent.get_navigation_map())
	NavigationServer2D.map_set_active(nav_agent.get_navigation_map(), true)
	
	nav_agent.target_position = finish_pos
	nav_agent.get_next_path_position()
	print(nav_agent.get_next_path_position())
	print("Target Reachable: " + str(nav_agent.is_target_reachable()))
	
	var asd = nav_agent.get_current_navigation_path()
	for c in asd:
		print(c)
	pass # Replace with function body.

func _process(delta):
	nav_agent.get_next_path_position()
	print(nav_agent.get_next_path_position())
	print("Target Reachable: " + str(nav_agent.is_target_reachable()))
