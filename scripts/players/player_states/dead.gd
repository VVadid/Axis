extends State

@export var player: Player


func physics_process(_delta: float) -> State:
	player.velocity.x = 0
	player.velocity.z = 0
	
	return null
