extends LocomotionState


@export var evade_hitbox_damage_data: DamageData


@export_node_path("State") var idle_state_path
@onready var idle_state = get_node(idle_state_path)

@export_node_path("State") var walk_state_path
@onready var walk_state = get_node(walk_state_path)

@export_node_path("State") var sprint_state_path
@onready var sprint_state = get_node(sprint_state_path)

@export_node_path("State") var fall_state_path
@onready var fall_state = get_node(fall_state_path)




var should_exit_state: bool = false
var evade_dir: Vector3

func enter() -> void:
	super()
	should_exit_state = false
	evade_dir = player.direction_vec

	player.is_evading = true
	player.hurtbox.monitoring = false
	player.evade_hitbox.monitorable = true
	player.evade_hitbox.damage_data = evade_hitbox_damage_data
	player.collision_shape_3d.shape.height = player.CAPSULE_HEIGHT / 2.0
	player.collision_shape_3d.position.y = player.CAPSULE_POSITION_Y / 2.0
	
	%AnimationTree.request_evade_one_shot()
	player.combat_manager.drain_stamina(player.evade_stamina_cost)

func process(delta: float) -> State:
	super(delta)
	if should_exit_state:
		if not player.is_on_floor():
			return fall_state
		elif not player.direction_vec:
			return idle_state
		elif Input.is_action_pressed("Sprint"):
			return sprint_state
		else:
			return walk_state
	
	return null


func physics_process(delta: float) -> State:
	player.velocity += player.get_gravity() * delta
	player.velocity.x = evade_dir.x * free_speed
	player.velocity.z = evade_dir.z * free_speed

	var target_rotation = atan2(-player.direction_vec.x, -player.direction_vec.z)
	if player.velocity:
		player.rotation.y = lerp_angle(player.rotation.y, target_rotation, 0.09)

	return null


func exit() -> void:
	super()
	player.is_evading = false
	player.hurtbox.monitoring = true
	player.evade_hitbox.monitorable = false
	player.collision_shape_3d.shape.height = player.CAPSULE_HEIGHT
	player.collision_shape_3d.position.y = player.CAPSULE_POSITION_Y


func transform_to_target_space() -> Vector3:
	var target_basis = Basis(Vector3.UP, atan2(to_target.x, to_target.z))
	return (target_basis * Vector3(-player.input_dir.x, 0, player.input_dir.y))
	

func transform_to_camera_space() -> Vector3:
	return (
		player.camera.global_basis * Vector3(player.input_dir.x, 0, -player.input_dir.y)
	)


func toggle_return_condition():
	should_exit_state = true
