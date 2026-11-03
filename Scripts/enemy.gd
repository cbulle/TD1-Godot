class_name Enemy

extends Area2D

@export var speed: float = 200.0
@export var max_pv: int = 2
@export var knockback: float = 500.0
@export var knockback_recovery: float = 2000.0
@export var explosion_scene: PackedScene

var current_pv: int = max_pv
var velocity: Vector2

@onready var sprite: Sprite2D = $Sprite2D
@onready var flash_timer: Timer = $flash

func _ready() -> void:
	velocity = Vector2.DOWN * speed

func _physics_process(delta: float) -> void:
	velocity = velocity.move_toward(velocity , knockback_recovery * delta)
	global_position += velocity * delta
	if global_position.y > 800.0:
		queue_free()

func take_damage(damage: int) -> void:
	current_pv -= damage
	sprite.modulate = Color(10, 10, 10)
	flash_timer.start()
	if current_pv <= 0:
		die()
		return
	velocity.y = -knockback


func die() -> void:
	var explosion: Node2D = explosion_scene.instantiate()
	explosion.global_position = global_position
	get_tree().current_scene.add_child(explosion)
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.has_method("take_damage"):
		area.take_damage(1)
		die()

func _on_flash_timeout() -> void:
	sprite.modulate = Color.WHITE
