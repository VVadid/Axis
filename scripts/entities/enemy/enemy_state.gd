class_name EnemyState
extends State

@export var enemy: Enemy
var to_player: Vector3


func physics_process(delta: float) -> State:
	super(delta)
	
	to_player = (enemy.player.global_position - enemy.global_position)
	
	enemy.velocity.x = enemy.direction_vec.x * enemy.speed
	enemy.velocity.z = enemy.direction_vec.z * enemy.speed
	
	enemy.velocity += enemy.get_gravity() * delta
	
	return null
