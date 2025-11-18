extends Enemy


@export var damage_data: DamageData

var is_player_in_proximity: bool
var should_attack: bool


@onready var state_machine: StateMachine = $StateMachine
@onready var anim_player: AnimationPlayer = $vampire/AnimationPlayer
@onready var fx_anim_player: AnimationPlayer = $FXAnimPlayer
@onready var claw_hitbox: Hitbox = $vampire/Armature/Skeleton3D/BoneAttachment3D/Hitbox
@onready var player_chase_detector: Area3D = $PlayerChaseDetector
@onready var combat_manager: Node = $CombatManager
@onready var mesh: MeshInstance3D = $vampire/Armature/Skeleton3D/Vampire


func _ready() -> void:
	state_machine.initialize()
	mesh.set_surface_override_material(0, mesh.get_active_material(0).duplicate())
	claw_hitbox.damage_data = damage_data
	combat_manager.combat_stats = combat_stats


func _process(delta: float) -> void:
	state_machine.process(delta)
	is_player_in_proximity = player_chase_detector.is_player_in_proximity


func _physics_process(delta: float) -> void:
	state_machine.physics_process(delta)
	move_and_slide()


func _input(event: InputEvent) -> void:
	state_machine.input(event)


func kill():
	is_alive = false
