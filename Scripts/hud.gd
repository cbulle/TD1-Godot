extends CanvasLayer

@onready var score_label: Label = $Score
@onready var pv: HBoxContainer = $PV
@onready var damage_flash: ColorRect = $Damage
@onready var game_over: Control = $GameOver

func _ready() -> void:
	GameManager.score_changed.connect(_on_score_changed)
	GameManager.player_life_changed.connect(_on_player_life_changed)
	score_label.text = "%06d" % GameManager.score

func _on_score_changed(score: int) -> void:
	score_label.text = "%06d" % score
	score_label.scale = Vector2(1.4, 1.4)
	create_tween().tween_property(score_label, "scale", Vector2.ONE, 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_player_life_changed(life: int) -> void:
	damage_flash.color = Color(1.0, 0, 0, 0.4)
	var flash_tween : Tween  = get_tree().create_tween()
	flash_tween.tween_property(damage_flash, "color:a", 0.0, 0.3)
	flash_tween.play()
	for i: int in pv.get_child_count():
		pv.get_child(i).visible = i < life
	if life == 0:
		game_over.visible = true 

func _on_restart_pressed() -> void:
	GameManager.restart()

func _on_quit_pressed() -> void:
	get_tree().quit()
