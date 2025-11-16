extends LocomotionState

@export var feet_hitbox_damage_data: DamageData
const STOMP_DAMAGE_SPEED_LIMIT: float = -5.2

@export_node_path("State") var idle_state_path
@onready var idle_state = get_node(idle_state_path)

@export_node_path("State") var sprint_state_path
@onready var sprint_state = get_node(sprint_state_path)


func enter() -> void:
	super()
	player.feet_hitbox.damage_data = feet_hitbox_damage_data
	#var plane_velocity = Vector3(player.velocity.x, 0, player.velocity.z)
	#free_speed = plane_velocity.length()
	#target_locked_speed = plane_velocity.length()


func physics_process(delta: float) -> State:
	super(delta)
	
	
	player.feet_hitbox.monitorable = player.velocity.y < STOMP_DAMAGE_SPEED_LIMIT
	
	print(player.feet_hitbox.monitorable)
	
	if player.is_on_floor():
		return idle_state
	return null


func input(event: InputEvent) -> State:
	if event.is_action("Sprint") and player.input_dir:
		return sprint_state
	return null


func exit() -> void:
	player.feet_hitbox.monitorable = false
	
