class_name Hurtbox
extends Area3D


signal was_hit(id:int, damage_data: DamageData)

@export var root: Node3D
var id: int

func _ready() -> void:
	id = randi()

func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("hitbox"):
		var hit_direction = (root.global_position - area.owner.global_position).normalized()
		area.damage_data.hit_direction = hit_direction
		was_hit.emit(id, area.damage_data)
		area.struck.emit(area.id)
