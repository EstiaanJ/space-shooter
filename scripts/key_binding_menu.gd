extends Control


@onready var input_button_scene = preload("res://scenes/input_button.tscn")
@onready var action_list = $PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/ActionList

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
		var input_label = button.find_child("LabelInput")
		action_label.text = input_actions[action]
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix(" (Physical)")
		else:
			input_label.text = ""
		action_list.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button,action))


func _on_input_button_pressed(button, action):
	if !is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("LabelInput").text = "Press key to bind..."

func _input(event):
	if is_remapping:
		if event is InputEventKey || event is InputEventJoypadButton || event is InputEventMouseButton || event is InputEventJoypadMotion:
			if event is InputEventMouseButton && event.double_click:
				event.double_click = false
			InputMap.action_erase_event(action_to_remap,event) #TODO: Fix this to add more than one bind
			InputMap.action_add_event(action_to_remap,event)
			_update_action_list(remapping_button, event)
			is_remapping = false
			action_to_remap = null
			remapping_button = null
			accept_event()


func _update_action_list(button, event):
	button.find_child("LabelInput").text = event.as_text().trim_suffix(" (Physical)")


func _on_reset_button_pressed() -> void:
	create_action_list()
