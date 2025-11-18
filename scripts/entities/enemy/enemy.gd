class_name Enemy
extends CharacterBody3D

@export var player: Player
@export var speed: float = 2.0

var is_alive: bool = true
var direction_vec: Vector3
