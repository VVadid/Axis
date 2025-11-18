extends AnimationTree

@export var vampire: CharacterBody3D
var attack_in_progress: bool

func _process(_delta: float) -> void:
	var state: State = vampire.state_machine.current_state
	
	var locomotion_blend_position_conditions: bool = (
		vampire.state_machine.current_state.name != "Idle"
		and vampire.state_machine.current_state.name != "Knockback"
	)
	
	set("parameters/Locomotion/blend_position", 1 if locomotion_blend_position_conditions else 0)
	
	if state.name == "Attack" and not attack_in_progress:
		set("parameters/ClawOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		attack_in_progress = true

	if attack_in_progress and get("parameters/ClawOneShot/active") == false:
		attack_in_progress = false
	pass
	
func _on_combat_manager_died(_damage_data: DamageData) -> void:
	vampire.fx_anim_player.play("death")
	set("parameters/DeathBlend/blend_amount", 1)


func _on_combat_manager_took_damage(_damage_data: DamageData) -> void:
	vampire.fx_anim_player.play("hit")
