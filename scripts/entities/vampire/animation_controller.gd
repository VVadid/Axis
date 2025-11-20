extends AnimationTree

@export var vampire: CharacterBody3D
var attack_in_progress: bool

func _process(_delta: float) -> void:
	var anim_playback: AnimationNodeStateMachinePlayback = get("parameters/playback")
	var anim_state = anim_playback.get_current_node()
	
	
func _on_combat_manager_died(_damage_data: DamageData) -> void:
	vampire.fx_anim_player.play("death")


func _on_combat_manager_took_damage(_damage_data: DamageData) -> void:
	vampire.fx_anim_player.play("hit")
