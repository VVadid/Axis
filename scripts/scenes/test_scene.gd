extends Node3D

@onready var hitbox: Hitbox = $Hitbox


func _ready() -> void:
	var damage_data = DamageData.new()
	damage_data.damage_value = 10.0
	hitbox.damage_data = damage_data
	
