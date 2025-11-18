extends Node

var is_active: bool = false

func apply_hitstop(duration: float, scale: float = 0.0):
	if is_active:
		return
	is_active = true

	Engine.time_scale = scale

	await get_tree().create_timer(duration, true, false, true).timeout
	
	Engine.time_scale = 1.0
	is_active = false
