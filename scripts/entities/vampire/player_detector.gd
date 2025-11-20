extends Area3D


const MAX_FOV = 2*PI/3

@export var enemy: Enemy

var is_player_in_proximity: bool


func can_see_player() -> bool:
	return is_player_in_proximity and is_player_in_fov()


func is_player_in_fov() -> bool:
	var forward: Vector3 = enemy.global_transform.basis.z
	var to_player: Vector3 = (enemy.player.global_position - enemy.global_position).normalized()
	var angle_to = forward.angle_to(to_player)
	
	return angle_to < MAX_FOV * 0.5


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		is_player_in_proximity = true


func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		is_player_in_proximity = false
