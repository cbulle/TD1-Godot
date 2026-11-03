class_name Spawnner
extends Node2D

@export var enemy_scene: PackedScene
@export var x_range: float = 300.0

func _on_timer_timeout() -> void:
	var enemy: Node2D = enemy_scene.instantiate()
	enemy.global_position = global_position
	enemy.global_position.x = randf_range(-x_range , x_range)
	get_tree().current_scene.add_child(enemy)
