class_name Hitbox
extends Area3D


signal struck(id: int)

var id: int
var damage_data: DamageData


func _ready() -> void:
	id = randi()
