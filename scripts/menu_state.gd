extends Node

var stack: Array = []
@export var origin_menu_path: NodePath
@onready var origin_menu: Node = get_node_or_null(origin_menu_path)

func push_menu(menu: Node) -> void:
	# hide current
	if stack.size() > 0:
		stack.back().visible = false
	# show new
	menu.visible = true
	stack.append(menu)

func pop_menu() -> void:
	if stack.is_empty():
		return
	var top = stack.pop_back()
	top.visible = false
	if stack.size() > 0:
		stack.back().visible = true

func replace_menu(menu: Node) -> void:
	# useful for switching without keeping the old one
	if stack.size() > 0:
		var old = stack.pop_back()
		old.visible = false
	push_menu(menu)
	

func reset_menu() -> void:
	# hide/free everything on the stack
	while not stack.is_empty():
		var m: Node = stack.pop_back()
		if is_instance_valid(m):
			m.visible = false
			# optional: free if you want dynamic menus removed
			# if m.has_meta("free_on_close") and m.get_meta("free_on_close"):
			#     m.queue_free()

	# show origin (if provided), and start stack from there
	if is_instance_valid(origin_menu):
		origin_menu.visible = true
		stack.append(origin_menu)
	else:
		# no origin: leave all hidden
		stack.clear()

func current_menu() -> Node:
	return stack.back() if not stack.is_empty() else null
