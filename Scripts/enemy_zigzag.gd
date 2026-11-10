class_name ZigzagEnemy
extends Enemy

@export var frequency: float = 5.0
@export var amplitude: float = 150.0
var time_elapsed: float = 0.0

func _physics_process(delta: float) -> void:
	time_elapsed += delta
	global_position.x += cos(time_elapsed * frequency) * amplitude * delta
	super(delta)
