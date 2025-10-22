extends Control

signal continue_on


func _on_continue_button_pressed() -> void:
	continue_on.emit()
