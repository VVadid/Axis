extends AnimationTree

@export var vampire: CharacterBody3D
var attack_in_progress: bool

func _process(_delta: float) -> void:
	set("parameters/Locomotion/blend_position", 1 if vampire.velocity else 0)
	if vampire.should_attack and not attack_in_progress:
		set("parameters/ClawOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		attack_in_progress = true

	if attack_in_progress and get("parameters/ClawOneShot/active") == false:
		attack_in_progress = false

func _on_combat_manager_died(_damage_data: DamageData) -> void:
	vampire.vfx_anim_player.play("death_flash")
	set("parameters/DeathBlend/blend_amount", 1)


func _on_combat_manager_took_damage(_damage_data: DamageData) -> void:
	vampire.vfx_anim_player.play("hit_flash")
