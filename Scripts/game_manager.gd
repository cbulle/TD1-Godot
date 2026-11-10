extends Node
 
signal score_changed(score: int)
signal player_life_changed(life: int)
signal game_over

var score: int = 0
var is_game_over: bool = false 

func add_score(pts: int)-> void :
	score += pts 
	score_changed.emit(score)

func trigger_game_over() -> void:
	Engine.time_scale = 0.3
	is_game_over = true
	get_tree().create_timer(1.5, true, false, true).timeout.connect(_on_game_over_timer_end)

func restart() -> void:
	score = 0 
	get_tree().paused = false
	get_tree().reload_current_scene()

func hitstop(duration: float) -> void:
	Engine.time_scale = 0.05
	await get_tree().create_timer(duration, true, false, true).timeout
	Engine.time_scale = 1.0
	
func _on_game_over_timer_end() -> void:
	Engine.time_scale = 1.0
	game_over.emit()
