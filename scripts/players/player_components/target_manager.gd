extends Area3D

signal released_target

@onready var reticle: Sprite3D = $"../Reticle"
@export var player: Player

var target_candidates = []

var switch_timer = 0.0
var switch_cooldown = 0.25
var switch_threshold = 20.0

const ALIGNMENT_WEIGHT = 0.4
const PROXIMITY_WEIGHT = 0.6


func _process(delta: float) -> void:
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

	switch_timer += delta


func _input(event):
	if not player.is_target_locked or player.current_target == null:
		return

	if event is InputEventMouseMotion:
		var dx = event.relative.x
		

		if abs(dx) > switch_threshold and switch_timer >= switch_cooldown:
			if dx > 0:
				switch_target(+1)
			else:
				switch_target(-1)
			switch_timer = 0.0


func set_target() -> void:
	var best_candidate = { "body": null, "score": -1.0 }
	
	for candidate_data in get_valid_candidates():
		if candidate_data["score"] > best_candidate["score"]:
			best_candidate = candidate_data
	
	player.current_target = best_candidate["body"]
	
	

func release_target() -> void:
	player.current_target = null
	released_target.emit()


func switch_target(direction: int) -> void:
	if player.current_target == null or target_candidates.is_empty():
		return

	var current = player.current_target
	var right_side = []
	var left_side = []

	for candidate_data in target_candidates:
		var candidate = candidate_data["body"]
		if candidate == current or not is_instance_valid(candidate):
			continue

		var dir_vec = (candidate.global_position - current.global_position).normalized()
		var camera_right = player.camera.global_transform.basis.x
		var lateral = camera_right.dot(dir_vec)
		var angle = -player.camera.global_basis.z.angle_to(dir_vec)

		var entry = {"body": candidate, "angle": angle}
		if lateral > 0:
			right_side.append(entry)
		else:
			left_side.append(entry)

	var chosen = null
	if direction > 0 and right_side.size() > 0:
		chosen = right_side[0]
		for e in right_side:
			if e["angle"] < chosen["angle"]:
				chosen = e
	elif direction < 0 and left_side.size() > 0:
		chosen = left_side[0]
		for e in left_side:
			if e["angle"] < chosen["angle"]:
				chosen = e

	if chosen != null:
		player.current_target = chosen["body"]


func get_valid_candidates():
	var valid_candidates = []
	for candidate_data in target_candidates:
		if is_instance_valid(candidate_data["body"]) and candidate_data["score"] >= 0:
			valid_candidates.append(candidate_data)
	return valid_candidates


func set_candidate_scores() -> void:
	var remove_list = []
	for candidate_data in target_candidates:
		if not is_instance_valid(candidate_data["body"]):
			remove_list.append(candidate_data)
	for candidate_data in remove_list:
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
	if body.is_in_group("targetable"):
		for cd in target_candidates:
			if cd["body"] == body:
				return
		target_candidates.append({"body": body, "score": 0.0})


func _on_body_exited(body: Node3D) -> void:
	for i in target_candidates.size():
		if target_candidates[i]["body"] == body:
			target_candidates.remove_at(i)
			break
