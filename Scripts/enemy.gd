class_name Enemy
extends Area2D

@export var speed: float = 200.0
@export var max_pv: int = 2
@export var knockback: float = 60.0
@export var knockback_recovery: float = 900.0
@export var explosion_scene: PackedScene
@export var debris_scene: PackedScene
@export var score: int = 10

var current_pv: int = max_pv
var velocity: Vector2

@onready var sprite: Sprite2D = $Sprite2D
@onready var flash_timer: Timer = $flash

func _ready() -> void:
	velocity = Vector2.DOWN * speed

func _physics_process(delta: float) -> void:
	velocity = velocity.move_toward(velocity, knockback_recovery * delta)
	global_position += velocity * delta
	if global_position.y > 800.0:
		queue_free()

func take_damage(damage: int) -> void:
	current_pv -= damage
	sprite.modulate = Color(10, 10, 10)
	flash_timer.start()
	velocity.y = -knockback * 0.3
	if current_pv <= 0:
		die(true)
		return

func die(killed_by_player: bool) -> void:
	if explosion_scene:
		var explosion: Node2D = explosion_scene.instantiate()
		explosion.global_position = global_position
		get_tree().current_scene.add_child(explosion)
	
	if debris_scene:
		var debris: Node2D = debris_scene.instantiate()
		debris.global_position = global_position
		get_tree().current_scene.add_child(debris)
	
	var camera: Camera2D = get_viewport().get_camera_2d()
	if camera:
		camera.add_trauma(0.25)
	GameManager.hitstop(0.04)
	
	queue_free()
	if killed_by_player:
		GameManager.add_score(score)

func _on_area_entered(area: Area2D) -> void:
	if area.has_method("take_damage"):
		area.take_damage(1)
		die(false)

func _on_flash_timeout() -> void:
	sprite.modulate = Color.WHITE
