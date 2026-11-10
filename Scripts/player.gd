class_name Player
extends Area2D

@export var speed: float = 600.0
@export var acceleration: float = 4000.0
@export var max_rotation: float = 15.0
@export var x_limit: float = 320.0
@export var y_limit: float = 640.0
@export var pv: int = 3
@export var explosion_fx: PackedScene

@onready var sprite: Sprite2D = $Sprite2D
@onready var hurt_sound: AudioStreamPlayer2D = $HurtSound
@onready var invincible_timer: Timer = $InvincibleTimer

var velocity: Vector2 = Vector2.ZERO
var current_pv: int = pv 
var is_invincible: bool = false

func _physics_process(delta: float) -> void:
	var target_velocity: Vector2 = read_direction() * speed
	velocity = velocity.move_toward(target_velocity, acceleration * delta)
	position += velocity * delta
	position.x = clamp(position.x, -x_limit, x_limit)
	position.y = clamp(position.y, y_limit / 3.0, y_limit)
	sprite.rotation = deg_to_rad(max_rotation) * velocity.x / speed

func read_direction() -> Vector2:
	var direction: Vector2 = Vector2.ZERO
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("up", "down")
	if Input.is_action_pressed("touch"):
		var distance_to_finger: Vector2 = get_global_mouse_position() - global_position
		direction.x = clamp(distance_to_finger.x / 60.0, -1.0, 1.0)
		direction.y = clamp(distance_to_finger.y / 60.0, -1.0, 1.0)
	return direction

func take_damage(damage: int) -> void:
	if is_invincible or (invincible_timer and invincible_timer.time_left > 0.0):
		return
	
	is_invincible = true
	if invincible_timer:
		invincible_timer.start()
	
	var blink_tween: Tween = get_tree().create_tween()
	blink_tween.tween_property(sprite, "modulate:a", 0.4, 0.25)
	blink_tween.tween_property(sprite, "modulate:a", 1.0, 0.1)
	blink_tween.set_loops(5)
	blink_tween.play()
	
	current_pv -= damage
	GameManager.player_life_changed.emit(current_pv)
	GameManager.hitstop(0.2)
	
	if hurt_sound:
		hurt_sound.play()
	
	var camera: Camera2D = get_viewport().get_camera_2d()
	if camera and camera.has_method("add_trauma"):
		camera.add_trauma(0.6)
	
	if current_pv <= 0:
		if explosion_fx:
			var explosion: Node2D = explosion_fx.instantiate()
			explosion.global_position = global_position
			explosion.scale = Vector2.ONE * 2.0
			get_tree().current_scene.add_child(explosion)
		
		visible = false
		GameManager.trigger_game_over()

func _on_invincible_timer_timeout() -> void:
	is_invincible = false
	if sprite:
		sprite.modulate.a = 1.0
