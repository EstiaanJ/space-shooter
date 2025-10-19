extends Control

@onready var game_scene = get_tree().root.get_node("Game")


func _on_resume_run_pressed() -> void:
	game_scene.pauseMenu()


func _on_restart_run_pressed() -> void:
	game_scene.pauseMenu()
	game_scene.restart_run()


func _on_abandon_run_pressed() -> void:
	pass # Replace with function body.


func _on_settings_pressed() -> void:
	pass # Replace with function body.


func _on_quit_to_main_menu_pressed() -> void:
	pass # Replace with function body.


func _on_quit_to_desktop_pressed() -> void:
	game_scene.quit_game()
