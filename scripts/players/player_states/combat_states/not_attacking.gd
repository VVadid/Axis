extends PlayerState


@export_node_path("State") var attack1_state_path
@onready var attack1_state = get_node(attack1_state_path)

@export_node_path("State") var attack2_state_path
@onready var attack2_state = get_node(attack2_state_path)

@export_node_path("State") var heavy_attack1_state_path
@onready var heavy_attack1_state = get_node(heavy_attack1_state_path)



var combo_window_open: bool = false

func enter() -> void:
	super()
	player.is_attacking = false


func input(event: InputEvent) -> State:
	super(event)
	
	if event.is_action_pressed("Attack") and player.combat_manager.has_enough_stamina(attack1_state.stamina_cost):
		if player.is_target_locked and player.input_dir.x != 0:
			return attack2_state
		else:
			return attack1_state
	
	
	
	if event.is_action_pressed("Heavy Attack") and player.combat_manager.has_enough_stamina(heavy_attack1_state.stamina_cost):
		if player.is_on_floor() and not player.is_sprinting:
			return heavy_attack1_state
	
	return null
