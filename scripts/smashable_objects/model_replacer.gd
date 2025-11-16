extends Node3D

@export var PIECES: PackedScene


func replace_model(explodes: bool, intensity: float) -> void:
	var pieces: Pieces = PIECES.instantiate()
	pieces.global_transform = owner.global_transform
	get_tree().current_scene.add_child(pieces)
	
	pieces.break_object(explodes, intensity)
	
	owner.queue_free()
