class_name Enemy
extends CharacterBody3D

@export var player: Player
@export var speed: float = 2.0
@export var combat_stats: CombatStats

var is_alive: bool = true
var knockback_vec: Vector3
var direction_vec: Vector3
