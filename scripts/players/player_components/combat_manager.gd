extends Node

signal died(damage_data: DamageData)
signal took_damage(damage_data: DamageData)
signal struck(damage_data: DamageData)

@export var combat_stats: CombatStats

#@export var hurtbox: Hurtbox
#@export var hitbox: Hitbox

@export var hitboxes: Array[Hitbox]
@export var hurtboxes: Array[Hurtbox]



func _ready() -> void:
	for hurtbox in hurtboxes:
		hurtbox.was_hit.connect(_on_was_hit)
	
	for hitbox in hitboxes:
		hitbox.struck.connect(_on_struck)


func take_damage(data: DamageData):
	combat_stats.health -= data.damage_value
	if combat_stats.health <= 0:
		died.emit(data)
	else:
		took_damage.emit(data)


func has_enough_stamina(amount: float) -> bool:
	return (combat_stats.stamina - amount > 0)


func drain_stamina(amount: float) -> void:
	combat_stats.stamina -= amount


func _on_was_hit(id:int, data: DamageData):
	for hurtbox in hurtboxes:
		if hurtbox.id == id:
			take_damage(data)


func _on_struck(id: int):
	for hitbox in hitboxes:
		if hitbox.id == id:
			struck.emit(hitbox.damage_data)
