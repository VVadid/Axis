extends EnemyState


func enter() -> void:
	super()
	enemy.is_alive = false


func physics_process(delta: float) -> State:
	super(delta)
	enemy.direction_vec = Vector3.ZERO
	return null
