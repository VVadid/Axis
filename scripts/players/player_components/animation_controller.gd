extends AnimationTree


enum FreeBlend {
	WALK = 0,
	SPRINT = 1
}


@export var player: Player
@onready var vfx_animation_player: AnimationPlayer = $"../VFXAnimationPlayer"

var locomotion_blend: Vector2 = Vector2.ZERO
var desired_locomotion_blend: Vector2 = Vector2.ZERO 


var jump_blend: float
var desired_jump_blend: float


func _process(delta: float) -> void:
	
	desired_locomotion_blend = player.input_dir
	desired_locomotion_blend *= 2 if player.locomotion_state_machine.current_state.name == "Sprint" else 1
	
	desired_jump_blend = float(int(locomotion_blend.length()))
	
	locomotion_blend = lerp(locomotion_blend, desired_locomotion_blend, 10 * delta)
	jump_blend = lerp(jump_blend, desired_jump_blend, 10 * delta)
	
	
	#fall_blend = lerp(fall_blend, desired_fall_blend, 10 * delta)
	set("parameters/Locomotion/FreeLocomotion/blend_position", locomotion_blend.length() -1)
	set("parameters/Locomotion/TargetedLocomotion/blend_position", locomotion_blend)
	set("parameters/Blend2/blend_amount", 1 if player.is_attacking else 0)

func request_evade_one_shot():
	set("parameters/EvadeOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)


func _on_combat_manager_took_damage(_damage_data: DamageData) -> void:
	vfx_animation_player.play("VFX/damage_flash")
	set("parameters/ImpactOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func _on_combat_manager_died(_damage_data: DamageData) -> void:
	vfx_animation_player.play("VFX/death_flash")
	set("parameters/DeathBlend/blend_amount", 1)
	
