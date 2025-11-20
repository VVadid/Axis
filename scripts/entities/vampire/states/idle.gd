extends EnemyState

@export_node_path("State") var chase_state_path: NodePath
@onready var chase_state: State = get_node(chase_state_path)



func process(delta: float) -> State:
	super(delta)
	if %PlayerDetector.can_see_player():
		return chase_state
	
	return null


func physics_process(delta: float) -> State:
	super(delta)
	enemy.direction_vec = Vector3.ZERO
	return null
