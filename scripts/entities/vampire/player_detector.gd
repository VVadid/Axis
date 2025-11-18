extends Area3D


var is_player_in_proximity: bool


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		is_player_in_proximity = true


func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		is_player_in_proximity = false
