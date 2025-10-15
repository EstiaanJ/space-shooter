extends AnimatedSprite2D

func _ready() -> void:
	play()  # Start playing the animation immediately

func _on_animation_finished() -> void:
	queue_free()
