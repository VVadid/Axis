extends LocomotionState

@export_node_path("State") var fall_state_path
@onready var fall_state = get_node(fall_state_path)

@export_node_path("State") var idle_state_path
@onready var idle_state = get_node(idle_state_path)


func enter() -> void:
	super()
	player.velocity.y = player.sprint_jump_speed if Input.is_action_pressed("Sprint") else player.jump_speed
	player.combat_manager.drain_stamina(player.jump_stamina_cost)
	#var plane_velocity = Vector3(player.velocity.x, 0, player.velocity.z)
	#free_speed = plane_velocity.length()
	#target_locked_speed = plane_velocity.length()

func physics_process(delta: float) -> State:
	super(delta)
	
	if player.velocity.y < 0:
		return fall_state
	
	return null
