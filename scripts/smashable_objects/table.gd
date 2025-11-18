extends RigidBody3D


var explodes_on_breaking: bool = false


func _physics_process(_delta: float) -> void:
	if not $RayCast3D.is_colliding():
		sleeping = false


func _on_combat_manager_died(_damage_data: DamageData) -> void:
	$ModelReplacer.replace_model(explodes_on_breaking, 6.0)
	
