extends EnemyState


func enter() -> void:
	enemy.is_alive = false


func physics_process(_delta: float) -> State:
	enemy.direction_vec = Vector3.ZERO
	return null
