extends CharacterBody3D


@export var player: Player
@export var damage_data: DamageData

var is_alive: bool = true
var speed: float = 0.5
var should_move: bool
var should_attack: bool

@onready var anim_player: AnimationPlayer = $vampire/AnimationPlayer
@onready var vfx_anim_player: AnimationPlayer = $VFXAnimPlayer
@onready var claw_hitbox: Hitbox = $vampire/Armature/Skeleton3D/BoneAttachment3D/Hitbox

func _ready() -> void:
	claw_hitbox.damage_data = damage_data


func _process(delta: float) -> void:
	var dir: Vector3 = player.global_position - global_position
	
	if should_move and is_alive:
		velocity.x = dir.x * speed
		velocity.z = dir.z * speed
	else:
		velocity.x = 0
		velocity.z = 0
	
	if should_attack or should_move:
		rotation.y = atan2(dir.x, dir.z) + PI/8

	velocity += get_gravity() * delta
	
	move_and_slide()



func kill():
	is_alive = false


func _on_player_detection_area_body_entered(body: Node3D) -> void:
	if body is Player:
		should_move = true


func _on_player_detection_area_body_exited(body: Node3D) -> void:
	if body is Player:
		should_move = false


func _on_attack_radius_body_entered(body: Node3D) -> void:
	if body is Player:
		should_attack = true
		should_move = false


func _on_attack_radius_body_exited(body: Node3D) -> void:
	if body is Player:
		should_attack = false
		should_move = true
