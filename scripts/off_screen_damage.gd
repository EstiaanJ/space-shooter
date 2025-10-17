extends CanvasModulate

var on_screen = true

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	visible = false
	on_screen = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	visible = true
	on_screen = false
