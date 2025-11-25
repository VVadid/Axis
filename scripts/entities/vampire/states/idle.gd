extends EnemyState

@export_node_path("State") var chase_state_path: NodePath
@onready var chase_state: State = get_node(chase_state_path)

@export_node_path("State") var knockback_state_path: NodePath
@onready var knockback_state: State = get_node(knockback_state_path)

@export_node_path("State") var dead_state_path: NodePath
@onready var dead_state: State = get_node(dead_state_path)

var return_knockback_state: bool = false
const KNOCKBACK_MULTIPLIER: float = 5.0


func enter() -> void:
	super()
	return_knockback_state = false


func process(delta: float) -> State:
	super(delta)
	if %PlayerDetector.can_see_player():
		enemy.is_alerted = true
		return chase_state
	
	if return_knockback_state:
		return knockback_state
	
	if not enemy.is_alive:
		return dead_state
	
	return null


func physics_process(delta: float) -> State:
	super(delta)
	enemy.direction_vec = Vector3.ZERO
	return null


func _on_combat_manager_took_damage(damage_data: DamageData) -> void:
	return_knockback_state = true
	enemy.knockback_vec = damage_data.hit_direction * calculate_knockback(
		damage_data.stagger_value, enemy.combat_stats.poise, KNOCKBACK_MULTIPLIER
		)


func _on_combat_manager_died(_damage_data: DamageData) -> void:
	enemy.is_alive = false
