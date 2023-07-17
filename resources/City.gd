extends Resource
class_name City
@export var name: String
@export var position: Vector2
@export var level: int
## Amount of coal resources (in tons)
@export var res_coal: int
## Amount of iron resources (in tons)
@export var res_iron: int
## Amount of workforce (not in tons)
@export var res_workforce: int
@export_category("Resource Demand")
## amount of coal demanded
@export var demand_coal: int
## amount of iron demanded
@export var demand_iron: int
## amount of workforce demanded
@export var demand_workforce: int

@export_category("Resource Production")
@export var producting_coal: int
@export var producting_iron: int
@export var producting_workforce: int
@export var production_period: float
@export var since_last_production: float = 0

@export_category("Resource demand")
@export var demanding_coal: int
@export var demanding_iron: int
@export var demanding_workforce: int
@export var demanding_period: float
@export var since_last_demand: float = 0
