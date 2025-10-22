extends Control


@onready var input_button_scene = preload("res://scenes/input_button.tscn")
@onready var action_list = $PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/ActionList
signal continue_game
signal back

var is_remapping = false 
var action_to_remap = null
var remapping_button = null

#TODO: investigate localization options to repalce below
var input_actions = {
	"quit": "Quit",
	"reset": "Reset",
	"shoot": "Shoot",
	"left_joy_right": "Move Right",
	"left_joy_left": "Move Left",
	"left_joy_up": "Move Up",
	"left_joy_down": "Move Down",
}

func _ready() -> void:
	create_action_list()
	
	
func create_action_list():
	InputMap.load_from_project_settings()
	for item in action_list.get_children():
		item.queue_free()
		
	for action in input_actions:
		var button = input_button_scene.instantiate()
		var action_label = button.find_child("LabelAction")
		action_label.text = input_actions[action]
		# Provide a helpful tooltip about remapping controls
		button.tooltip_text = "Click to rebind. In binding: ESC cancels, Backspace clears all."
		action_list.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button,action))
		
		# Set the initial display for this action
		action_to_remap = action
		_update_action_list(button)
		action_to_remap = null


func _on_input_button_pressed(button, action):
	if !is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("LabelInput").text = "Press a key to bind… (ESC: cancel, Backspace: clear all)"

func _input(event):
	if is_remapping:
		# Handle ESC key to cancel binding without changes
		if event is InputEventKey && event.keycode == KEY_ESCAPE && event.pressed:
			_cancel_remapping()
			accept_event()
			return
		
		# Handle backspace key to delete all bindings for this action
		if event is InputEventKey && event.keycode == KEY_BACKSPACE && event.pressed:
			_clear_all_bindings()
			accept_event()
			return
		
		# Handle actual key binding
		if event is InputEventKey || event is InputEventJoypadButton || event is InputEventMouseButton || event is InputEventJoypadMotion:
			if event.pressed:  # Only process key press events, not releases
				# Skip mouse button events that might be accidental clicks
				if event is InputEventMouseButton:
					# Only process mouse buttons if they're not left click (which might be accidental)
					if event.button_index == MOUSE_BUTTON_LEFT:
						accept_event()
						return
					if event.double_click:
						event.double_click = false
				
				# Check if this key is already bound to another action
				_remove_key_from_other_actions(event)
				
				# Add the new binding
				InputMap.action_add_event(action_to_remap, event)
				_update_action_list(remapping_button)
				is_remapping = false
				action_to_remap = null
				remapping_button = null
				accept_event()


func _update_action_list(button):
	var events = InputMap.action_get_events(action_to_remap)
	var input_label = button.find_child("LabelInput")
	
	if events.size() == 0:
		input_label.text = "No bindings"
	elif events.size() == 1:
		input_label.text = events[0].as_text().trim_suffix(" (Physical)")
	else:
		# Display multiple bindings separated by commas
		var binding_texts = []
		for event in events:
			binding_texts.append(event.as_text().trim_suffix(" (Physical)"))
		input_label.text = ", ".join(binding_texts)


func _on_reset_button_pressed() -> void:
	create_action_list()


func _on_continue_game_pressed() -> void:
	continue_game.emit()


func _on_back_pressed() -> void:
	back.emit()


func _cancel_remapping():
	"""Cancel the current remapping operation without making any changes"""
	# Restore the button's display to show current bindings
	_update_action_list(remapping_button)
	is_remapping = false
	action_to_remap = null
	remapping_button = null


func _clear_all_bindings():
	"""Remove all bindings for the current action"""
	InputMap.action_erase_events(action_to_remap)
	_update_action_list(remapping_button)
	is_remapping = false
	action_to_remap = null
	remapping_button = null


func _remove_key_from_other_actions(event):
	"""Remove the given event from all other actions to prevent conflicts"""
	for action_name in input_actions.keys():
		if action_name != action_to_remap:
			var events = InputMap.action_get_events(action_name)
			for existing_event in events:
				if _events_match(event, existing_event):
					InputMap.action_erase_event(action_name, existing_event)
					break


func _events_match(event1: InputEvent, event2: InputEvent) -> bool:
	"""Check if two input events represent the same key/button"""
	if event1.get_class() != event2.get_class():
		return false
	
	match event1.get_class():
		"InputEventKey":
			return event1.keycode == event2.keycode
		"InputEventJoypadButton":
			return event1.button_index == event2.button_index
		"InputEventMouseButton":
			return event1.button_index == event2.button_index
		"InputEventJoypadMotion":
			return event1.axis == event2.axis && event1.axis_value == event2.axis_value
	
	return false
