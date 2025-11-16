extends RigidBody3D


@export var explodes_on_breaking: bool = true
@export var intensity: float = 6.0


func _physics_process(delta: float) -> void:
	if not $RayCast3D.is_colliding():
		sleeping = false


func _on_combat_manager_died(_damage_data: DamageData) -> void:
	$ModelReplacer.replace_model(explodes_on_breaking, 6.0)
	
