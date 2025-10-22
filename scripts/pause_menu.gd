extends Control

@onready var game_scene = get_tree().root.get_node("Game")
@onready var menu_state = $PauseMenuState
@onready var pause_menu_items = $PauseMenuItems


func _on_resume_run_pressed() -> void:
	game_scene.pauseMenu()


func _on_restart_run_pressed() -> void:
	game_scene.pauseMenu() #TODO: Add confirm
	game_scene.restart_run()


func _on_abandon_run_pressed() -> void:
	pass # Replace with function body.


func _on_settings_pressed() -> void:
	pause_menu_items.hide()
	menu_state.push_menu($SettingsMenu)


func _on_quit_to_main_menu_pressed() -> void:
	pass # Load Main Menu Scene, but first confirm with warning


func _on_quit_to_desktop_pressed() -> void:
	game_scene.quit_game() #TODO: Add confirm


func _on_settings_menu_goto_controls_menu() -> void:
	menu_state.push_menu($InputSettings)


#func back_a_level():
	
	

func _on_input_settings_back() -> void:
	menu_state.pop_menu()


func _on_input_settings_continue_game() -> void:
	$InputSettings.hide()
	$SettingsMenu.hide()
	$PauseMenuItems.show()
	menu_state.reset_menu()


func _on_settings_menu_back() -> void:
	pause_menu_items.show()
	menu_state.pop_menu()
