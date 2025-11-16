extends Node3D

@export var PIECES: PackedScene
@export var explodes: bool

func replace_model() -> void:
	var pieces: Node3D = PIECES.instantiate()
	pieces.transform = transform
	pieces.explodes = explodes
	get_parent().add_child(pieces)
	
	queue_free()


func _on_combat_manager_died(_damage_data: DamageData) -> void:
	replace_model()
