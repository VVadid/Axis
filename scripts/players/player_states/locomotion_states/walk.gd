extends LocomotionState
#Walk State


@export_node_path("State") var idle_state_path
@onready var idle_state = get_node(idle_state_path)

@export_node_path("State") var sprint_state_path
@onready var sprint_state = get_node(sprint_state_path)

@export_node_path("State") var jump_state_path
@onready var jump_state = get_node(jump_state_path)

@export_node_path("State") var fall_state_path
@onready var fall_state = get_node(fall_state_path)

@export_node_path("State") var evade_state_path
@onready var evade_state = get_node(evade_state_path)


var free_step_interval: float = 0.525
var targeted_step_interval: float = 0.675

var step_interval: float = free_step_interval
var step_timer: float = 0.0


func process(delta: float) -> State:
	step_timer -= delta
	step_interval = targeted_step_interval if player.is_target_locked else free_step_interval
	
	if step_timer <= 0:
		%FootstepAudioPlayer.play()
		step_timer = step_interval
	
	return null
	

func physics_process(delta: float) -> State:
	super(delta)
	if player.direction_vec == Vector3.ZERO:
		return idle_state
	
	if not player.is_on_floor():
		return fall_state
	
	return null


func input(event: InputEvent) -> State:
	super(event)
	if event.is_action_pressed("Sprint"):
		return sprint_state
	
	if event.is_action_pressed("Jump") and player.combat_manager.has_enough_stamina(player.jump_stamina_cost):
		return jump_state
	
	if event.is_action_released("Evade") and player.combat_manager.has_enough_stamina(player.evade_stamina_cost):
		return evade_state
	
	return null
