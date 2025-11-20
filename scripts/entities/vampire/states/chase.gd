extends EnemyState


@export_node_path("State") var idle_state_path: NodePath
@onready var idle_state: State = get_node(idle_state_path)

@export_node_path("State") var attack_state_path: NodePath
@onready var attack_state: State = get_node(attack_state_path)

@export_node_path("State") var dead_state_path: NodePath
@onready var dead_state: State = get_node(dead_state_path)

@export_node_path("State") var knockback_state_path: NodePath
@onready var knockback_state: State = get_node(knockback_state_path)


const ENTER_DISTANCE: float = 1.0
const KNOCKBACK_MULTIPLIER: float = 5.0

var return_dead_state: bool = false
var return_knockback_state: bool = false

func enter() -> void:
	super()
	return_dead_state = false
	return_knockback_state = false


func process(delta: float) -> State:
	super(delta)
	if not %PlayerDetector.can_see_player():
		return idle_state
	
	if to_player.length() < ENTER_DISTANCE:
		return attack_state
	
	if return_dead_state:
		return dead_state
	
	if return_knockback_state:
		return knockback_state
	
	return null


func physics_process(delta: float) -> State:
	super(delta)
	
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


func _on_combat_manager_took_damage(damage_data: DamageData) -> void:
	return_knockback_state = true
	enemy.knockback_vec = damage_data.hit_direction * calculate_knockback(
		damage_data.stagger_value, enemy.combat_stats.poise, KNOCKBACK_MULTIPLIER
		)
