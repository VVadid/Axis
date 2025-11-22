extends EnemyState

@export_node_path("State") var chase_state_path: NodePath
@onready var chase_state: State = get_node(chase_state_path)


const KNOCKBACK_SPEED: float = 5.0
const KNOCKBACK_DECELERATION: float = 10.0


var enter_damage_data: DamageData


func enter() -> void:
	super()
	enemy.velocity = enemy.knockback_vec


func process(delta: float) -> State:
	super(delta)
	
	return null


func physics_process(delta: float) -> State:
	to_player = (enemy.player.global_position - enemy.global_position)
	
	enemy.velocity.x = move_toward(enemy.velocity.x, 0, KNOCKBACK_DECELERATION * delta)
	enemy.velocity.z = move_toward(enemy.velocity.z, 0, KNOCKBACK_DECELERATION * delta)
	
	if enemy.velocity == Vector3.ZERO:
		return chase_state
	
	return null


func exit() -> void:
	super()
	enemy.is_alerted = true
