class_name Player
extends CharacterBody3D


# LOCOMOTION
@export var jump_speed: float = 5.0
@export var sprint_jump_speed: float = 5.0
@export var acceleration: float = 10.0
@export var deceleration: float = 10.0
@export var air_acceleration: float = 2.0
@export var air_deceleration: float = 2.0

@export var can_rotate: bool = true
var speed: float
var is_sprinting: bool


# COMBAT
var is_attacking: bool = false
var is_evading: bool = false


# TARGETING
var is_target_locked: bool = false
var current_target: Node3D


# INPUT
var input_dir: Vector2
var direction_vec: Vector3 = Vector3.ZERO


# CAMERA RIG
const SPRING_ARM_DEFAULT_OFFSET: Vector3 = Vector3(0, 2, 0)
var spring_arm_offset: Vector3


# STAMINA
const STAMINA_REGEN_RATE: float = 20.0
@export var max_stamina: float = 100.0
@export var jump_stamina_cost: float = 15.0
@export var evade_stamina_cost: float = 25.0


# COLLISION
const CAPSULE_HEIGHT: float = 2.0
const CAPSULE_POSITION_Y: float = 1.0


@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var locomotion_state_machine: StateMachine = $LocomotionStateMachine
@onready var combat_state_machine: StateMachine = $CombatStateMachine
@onready var camera_spring_arm: SpringArm3D = $SpringArm3D
@onready var camera: Camera3D = $SpringArm3D/Camera3D
@onready var combat_manager: Node = $CombatManager
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var hitbox: Hitbox = $Visuals/castle_guard_rig/Armature/Skeleton3D/SwordAttachment/Hitbox


func _ready() -> void:
	locomotion_state_machine.initialize()
	combat_state_machine.initialize()
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _process(delta: float) -> void:
	locomotion_state_machine.process(delta)
	combat_state_machine.process(delta)
	
	can_rotate = not hitbox.monitorable
	
	var stamina_regeneration_conditions: bool = (
		not is_attacking
		and is_on_floor()
		and not is_evading
		and combat_manager.combat_stats.stamina < max_stamina
	)
	if stamina_regeneration_conditions:
		combat_manager.combat_stats.stamina += STAMINA_REGEN_RATE * delta


func _physics_process(delta: float) -> void:
	locomotion_state_machine.physics_process(delta)
	combat_state_machine.physics_process(delta)
	
	camera_spring_arm.position = position + spring_arm_offset
	
	input_dir = Input.get_vector("Move Left", "Move Right", "Move Backward", "Move Forward")
	
	if Input.is_action_just_pressed("Target Lock"):
		%TargetManager.set_target()
	elif Input.is_action_just_released("Target Lock"):
		%TargetManager.release_target()
		
	is_target_locked = current_target != null
		
	move_and_slide()


func _input(event: InputEvent) -> void:
	locomotion_state_machine.input(event)
	combat_state_machine.input(event)
