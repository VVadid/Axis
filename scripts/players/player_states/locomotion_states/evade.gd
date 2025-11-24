extends LocomotionState

@export_node_path("State") var idle_state_path
@onready var idle_state = get_node(idle_state_path)

@export_node_path("State") var walk_state_path
@onready var walk_state = get_node(walk_state_path)

@export_node_path("State") var sprint_state_path
@onready var sprint_state = get_node(sprint_state_path)

@export_node_path("State") var fall_state_path
@onready var fall_state = get_node(fall_state_path)




var should_exit_state: bool = false

var enter_enemy
var enter_dir: Vector3
var input_dir: Vector2

const ORBITAL_SPEED: float = 4.0
const LINEAR_SPEED: float = 4.0
const EVADE_MAX_SPEED: float = 3.0


func enter() -> void:
	super()
	should_exit_state = false
	enter_dir = player.direction_vec
	input_dir = player.input_dir
	enter_enemy = player.current_target
	
	player.is_evading = true
	player.hurtbox.monitoring = false

	player.collision_shape_3d.shape.height = player.CAPSULE_HEIGHT / 2.0
	player.collision_shape_3d.position.y = player.CAPSULE_POSITION_Y / 2.0
	
	%RollAudioPlayer.play()
	
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
	if enter_enemy:
		var to_enemy: Vector3 = (
			enter_enemy.global_position - player.global_position
			).normalized()
		
		
		var orbital_dir: Vector3 = to_enemy.cross(
			Vector3.UP * sign(input_dir.x)
			).normalized()
		
		var linear_dir: Vector3 = to_enemy * sign(input_dir.y)
		
		var final_velocity = orbital_dir * ORBITAL_SPEED + linear_dir * LINEAR_SPEED
		
		if final_velocity.length() > EVADE_MAX_SPEED:
			final_velocity = final_velocity.normalized() * EVADE_MAX_SPEED
		
		player.velocity.x = final_velocity.x
		player.velocity.z = final_velocity.z
	else:
		player.velocity.x = enter_dir.x * free_speed
		player.velocity.z = enter_dir.z * free_speed
	
	player.velocity += player.get_gravity() * delta

	var target_rotation = atan2(-player.direction_vec.x, -player.direction_vec.z)
	if player.velocity:
		player.rotation.y = lerp_angle(player.rotation.y, target_rotation, 0.09)

	return null


func exit() -> void:
	super()
	enter_enemy = null
	player.is_evading = false
	player.hurtbox.monitoring = true
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


func _on_target_manager_released_target() -> void:
	enter_enemy = null
