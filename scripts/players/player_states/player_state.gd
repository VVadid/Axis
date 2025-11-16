class_name PlayerState
extends State


@export var player: Player

@export_node_path("State") var dead_state_path
@onready var dead_state = get_node(dead_state_path)



func process(_delta: float) -> State:
	if player.is_dead:
		return dead_state
	
	return null


func physics_process(_delta: float) -> State:
	if player.is_dead:
		return dead_state
	
	return null
