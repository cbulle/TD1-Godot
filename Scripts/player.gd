class_name Player
extends Area2D

@export var speed: float = 600.0
@export var acceleration: float = 4000.0
@export var max_rotation: float = 15.0
@export var x_limit: float = 320.0
@export var y_limit: float = 640.0
@export var pv: int = 3
@onready var sprite: Sprite2D = $Sprite2D
var velocity: Vector2 = Vector2.ZERO
var current_pv : int = pv 
	
 
	
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
	current_pv -= damage
	if current_pv <= 0:
		get_tree().reload_current_scene.call_deferred()

	
