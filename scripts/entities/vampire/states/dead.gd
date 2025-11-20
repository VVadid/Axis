extends EnemyState



func physics_process(delta: float) -> State:
	super(delta)
	enemy.direction_vec = Vector3.ZERO
	return null
