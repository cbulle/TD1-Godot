class_name Spawnner
extends Node2D

@export var enemy_scenes: Array[PackedScene] = []
@export var enemy_scene: PackedScene 
@export var x_range: float = 300.0

@export_category("Difficulté Progressive")
@export var min_wait_time: float = 0.4
@export var acceleration_rate: float = 0.01

@onready var timer: Timer = $Timer

func _process(delta: float) -> void:
	if timer and timer.wait_time > min_wait_time:
		timer.wait_time = max(min_wait_time, timer.wait_time - acceleration_rate * delta)

func _on_timer_timeout() -> void:
	var scene_to_spawn: PackedScene = null
	
	if not enemy_scenes.is_empty():
		scene_to_spawn = enemy_scenes.pick_random()
	elif enemy_scene:
		scene_to_spawn = enemy_scene
		
	if scene_to_spawn == null:
		return
		
	var enemy: Node2D = scene_to_spawn.instantiate()
	enemy.global_position = global_position
	enemy.global_position.x = randf_range(-x_range, x_range)
	get_tree().current_scene.add_child(enemy)
