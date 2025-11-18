extends EnemyState


@export_node_path("State") var idle_state_path: NodePath
@onready var idle_state: State = get_node(idle_state_path)

@export_node_path("State") var attack_state_path: NodePath
@onready var attack_state: State = get_node(attack_state_path)

@export_node_path("State") var dead_state_path: NodePath
@onready var dead_state: State = get_node(dead_state_path)


const ENTER_DISTANCE: float = 1.0

var return_dead_state: bool = false

func enter() -> void:
	return_dead_state = false


func process(_delta: float) -> State:
	if not enemy.is_player_in_proximity:
		return idle_state
	
	var to_player: Vector3 = enemy.global_position - enemy.player.global_position
	
	if to_player.length() < ENTER_DISTANCE:
		return attack_state
	
	if return_dead_state:
		return dead_state
	
	return null


func physics_process(_delta: float) -> State:
	enemy.direction_vec.x = (
		enemy.player.global_position - enemy.global_position
		).normalized().x
	enemy.direction_vec.z = (
		enemy.player.global_position - enemy.global_position
		).normalized().z
	
	
	enemy.rotation.y = atan2(enemy.direction_vec.x, enemy.direction_vec.z)
	
	return null


func _on_combat_manager_died(damage_data: DamageData) -> void:
	return_dead_state = true
