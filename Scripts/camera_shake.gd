extends Camera2D

@export_category("Shake Settings")
@export var decay: float = 1.5        
@export var max_offset: Vector2 = Vector2(16.0, 16.0) 
@export var max_roll: float = 0.05      

var trauma: float = 0.0
var noise: FastNoiseLite = FastNoiseLite.new()
var noise_y: float = 0.0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	noise.seed = randi()
	noise.frequency = 0.5

func _process(delta: float) -> void:
	trauma = max(trauma - decay * delta, 0.0)
	var shake: float = trauma * trauma
	
	if trauma > 0.0:
		noise_y += delta * 50.0
		offset = Vector2(
			randf_range(-1.0, 1.0) * max_offset.x * shake,
			randf_range(-1.0, 1.0) * max_offset.y * shake
		)
		rotation = randf_range(-1.0, 1.0) * max_roll * shake
	else:
		offset = Vector2.ZERO
		rotation = 0.0

func add_trauma(amount: float) -> void:
	trauma = min(trauma + amount, 1.0)
