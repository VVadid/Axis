class_name Pieces
extends Node3D


func break_object(explodes: bool, intensity: float) -> void:
	if explodes:
		for i in get_child_count():
			if get_child(i) is AudioStreamPlayer3D:
				continue
			var angle: float = TAU * i / get_child_count()
			var dir = Vector3(cos(angle), 0, sin(angle)).normalized()
			get_child(i).apply_central_impulse(dir * intensity)

	$AudioStreamPlayer3D.play(0.25)
	await get_tree().create_timer(5).timeout
	queue_free()
