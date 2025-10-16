extends Node2D

func _process(delta: float) -> void:
	await get_tree().create_timer(0.1).timeout
	queue_free()
