extends Camera3D


var shake_intensity: float = 0.0
var active_shake_time: float = 0.0

var shake_decay: float = 5.0

var shake_time: float = 0.0
var shake_time_speed: float = 20.0

var noise = FastNoiseLite.new()


func _physics_process(delta: float) -> void:
	if active_shake_time > 0:
		shake_time += delta * shake_time_speed
		active_shake_time -= delta
		
		h_offset = noise.get_noise_2d(shake_time, 0) * shake_intensity
		v_offset = noise.get_noise_2d(0, shake_time) * shake_intensity

		shake_intensity = max(shake_intensity - shake_decay * delta, 0)
	else:
		h_offset = lerp(h_offset, 0.0, 10.5 * delta)
		v_offset = lerp(v_offset, 0.0, 10.5 * delta)

func screen_shake(intensity: float, time: float):
	randomize()
	noise.seed = randi()
	noise.frequency = 2.0
	
	shake_intensity = intensity
	active_shake_time = time
	shake_time = 0.0


func _on_combat_manager_struck(_damage_data: DamageData) -> void:
	screen_shake(0.4, 0.1)
	HitStopManager.apply_hitstop(0.05, 0.05)


func _on_combat_manager_took_damage(damage_data: DamageData) -> void:
	screen_shake(0.6, 0.1)
