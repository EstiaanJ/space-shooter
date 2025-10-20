extends Control


signal goto_controls_menu

func _on_controls_pressed() -> void:
	goto_controls_menu.emit()
