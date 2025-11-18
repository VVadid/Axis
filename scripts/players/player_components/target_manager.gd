extends Area3D

signal released_target

@onready var reticle: Sprite3D = $"../Reticle"
@export var player: Player
var target_candidates = []


const ALIGNMENT_WEIGHT = 0.4
const PROXIMITY_WEIGHT = 0.6


func _process(_delta: float) -> void:
	set_candidate_scores()
	
	if Input.is_action_just_pressed("debug_button"):
		for candidate_data in get_valid_candidates():
			print(candidate_data["body"].name + ": " + str(candidate_data["score"]))
		print("--------------")
	
	if player.is_target_locked and player.current_target:
		reticle.visible = true
		var reticle_position = player.current_target.global_position
		var reticle_position_offset = Vector3(0, 2.5, 0)
	
		reticle.global_position = reticle_position + reticle_position_offset
		reticle.look_at(player.global_position)
		reticle.rotation.x = 0
		reticle.rotation.z = 0
	else:
		reticle.visible = false
		reticle.global_position = player.global_position




func set_target() -> void:
	var best_candidate = { "body": null, "score": 0.0 }
	
	for candidate_data in get_valid_candidates():
		if candidate_data["score"] > best_candidate["score"]:
			best_candidate = candidate_data
	
	player.current_target = best_candidate["body"]
	
	

func release_target() -> void:
	player.current_target = null
	released_target.emit()


func get_valid_candidates():
	var valid_candidates = target_candidates.duplicate()
	
	for candidate in valid_candidates:
		if candidate.score < 0:
			valid_candidates.erase(candidate)
	
	return valid_candidates


func set_candidate_scores() -> void:
	for candidate_data in target_candidates:
		if is_instance_valid(candidate_data):
			target_candidates.erase(candidate_data)

	for candidate_data in target_candidates:
		var score = (
			calculate_alignment_score(candidate_data["body"]) * ALIGNMENT_WEIGHT
			+ calculate_proximity_score(candidate_data["body"]) * PROXIMITY_WEIGHT
		)
		candidate_data["score"] = score





func calculate_alignment_score(candidate: Node3D) -> float:
	var dir = (candidate.global_position - player.camera.global_position).normalized()
	var camera_forward = -player.camera.global_basis.z
	return camera_forward.dot(dir)


func calculate_proximity_score(candidate: Node3D) -> float:
	var dir = (candidate.global_position - player.global_position)
	return 1 / (1 + dir.length())



func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("targetable") and not target_candidates.has(body):
		var candidate_data = {
			"body": body,
			"score": 0.0
		}
		target_candidates.append(candidate_data)


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("targetable"):
		for i in target_candidates.size():
			if target_candidates[i]["body"] == body:
				target_candidates.remove_at(i)
				break
