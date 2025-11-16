extends CharacterBody3D


const PUSH_MODIFIER: float = 0.5

@onready var combat_manager: Node = $CombatManager
@export var combat_stats: CombatStats

@onready var mesh: MeshInstance3D = $medieval_combat_dummy/Object_4


func _ready() -> void:
	combat_manager.combat_stats = combat_stats.duplicate(true)
	mesh.set_surface_override_material(0, mesh.get_active_material(0).duplicate())
	
	var feet_hitbox_damage_data = DamageData.new()
	feet_hitbox_damage_data.damage_value = 10.0
	$FeetHitbox.damage_data = feet_hitbox_damage_data


func _physics_process(delta: float) -> void:
	velocity += get_gravity() * delta
	velocity.x = lerp(velocity.x, 0.0, delta * 10)
	velocity.z = lerp(velocity.z, 0.0, delta * 10)
	move_and_slide()


func _on_combat_manager_died(damage_data: DamageData) -> void:
	velocity = damage_data.hit_direction * damage_data.damage_value * PUSH_MODIFIER
	%AnimationPlayer.play("die")


func _on_combat_manager_took_damage(damage_data: DamageData) -> void:
	velocity = damage_data.hit_direction * damage_data.damage_value * PUSH_MODIFIER
	%AnimationPlayer.play("take_damage")
	
