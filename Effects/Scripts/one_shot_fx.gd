# Effet "tire et oublie" fourni : les particules et le son démarrent tout seuls
# à l'apparition de la scène, puis l'effet se détruit après `duration` secondes.
# Pour l'utiliser : instancier la scène, la placer, l'ajouter à la scène courante.
extends Node2D

@export var duration: float = 1.0

func _ready() -> void:
	await get_tree().create_timer(duration, false).timeout
	queue_free()
