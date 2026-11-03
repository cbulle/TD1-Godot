class_name Bullet

extends Area2D

@export var speed: float = 900.0
@export var damage: int = 1
@export var hit_effect_scene: PackedScene

func _physics_process(delta: float) -> void:
	position += Vector2.UP.rotated(rotation) * speed * delta
	if abs(position.y) < -1000.0:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.has_method("take_damage"):
		area.take_damage(damage)

	if hit_effect_scene:
		var hit_effect: Node2D = hit_effect_scene.instantiate()
		hit_effect.global_position = global_position
		get_tree().current_scene.add_child(hit_effect)
	queue_free()
