extends Node3D

const INTENSITY: float = 6.0

var explodes: bool


func _ready() -> void:
	break_object()


func break_object() -> void:
	if explodes:
		for i in get_child_count():
			if get_child(i) is AudioStreamPlayer3D:
				continue
			var angle: float = TAU * i / get_child_count()
			var dir = Vector3(cos(angle), 0, sin(angle)).normalized()
			get_child(i).apply_central_impulse(dir * INTENSITY)

	$AudioStreamPlayer3D.play(0.25)
	await get_tree().create_timer(5).timeout
	queue_free()
