extends EnemyState

@export_node_path("State") var chase_state_path: NodePath
@onready var chase_state: State = get_node(chase_state_path)

@export_node_path("State") var dead_state_path: NodePath
@onready var dead_state: State = get_node(dead_state_path)

const EXIT_DISTANCE: float = 1.5

var return_dead_state: bool = false


func enter() -> void:
	super()
	return_dead_state = false


func process(delta: float) -> State:
	super(delta)
	var to_player: Vector3 = enemy.global_position - enemy.player.global_position
	
	if to_player.length() > EXIT_DISTANCE:
		return chase_state
	
	if return_dead_state:
		return dead_state
	
	return null


func physics_process(delta: float) -> State:
	super(delta)
	enemy.direction_vec = Vector3.ZERO
	var to_player: Vector3 = (enemy.player.global_position - enemy.global_position)
	enemy.rotation.y = atan2(to_player.x, to_player.z)
	return null


func _on_combat_manager_died(_damage_data: DamageData) -> void:
	return_dead_state = true
