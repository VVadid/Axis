extends StaticBody3D


var explodes_on_breaking: bool = false

func _on_combat_manager_died(_damage_data: DamageData) -> void:
	$ModelReplacer.replace_model(explodes_on_breaking, 6.0)
	
