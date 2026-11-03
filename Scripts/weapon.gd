class_name Weapon

extends Node2D

@export var bullet_scene: PackedScene
@export var time_between_shots: float = 0.5
@export var spread_degrees: float = 3.0
@export var muzzle_flash_scene: PackedScene

var cooldown: float = 0.0

@onready var sound: AudioStreamPlayer2D = $Shoot

func _ready() -> void:
	cooldown = time_between_shots

func _process(delta: float) -> void:
	cooldown -= delta
	if cooldown <= 0.0:
		shoot()
		cooldown = time_between_shots

func shoot() -> void:
	var bullet: Bullet = bullet_scene.instantiate()
	bullet.global_position = global_position
	bullet.rotation = global_rotation + deg_to_rad(randf_range(-spread_degrees, spread_degrees))
	get_tree().current_scene.add_child(bullet)
	sound.play()
	if muzzle_flash_scene:
		add_child(muzzle_flash_scene.instantiate())
