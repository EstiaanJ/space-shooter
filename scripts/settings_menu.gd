extends Control


signal goto_controls_menu
signal back

func _on_controls_pressed() -> void:
	goto_controls_menu.emit()


func _on_back_pressed() -> void:
	back.emit()


func _on_display_item_selected(index: int) -> void:
	var size := Vector2i(1280, 720) # default 720p
	match index:
		0:
			size = Vector2i(1280, 720)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1:
			size = Vector2i(1280, 720)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		2:
			size = Vector2i(1920, 1080)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		3:
			size = Vector2i(1920, 1080)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		4:
			size = Vector2i(2560, 1440)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		5:
			size = Vector2i(2560, 1440)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	# Apply resolution
	DisplayServer.window_set_size(size)
