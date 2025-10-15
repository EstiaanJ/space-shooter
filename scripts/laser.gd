extends Area2D

@export var speed = 400
var direction: Vector2 = Vector2.UP
var team

func initialize(rot: float, creatorIn: String) -> void:
	rotation = rot
	direction = Vector2.UP.rotated(rotation)
	team = creatorIn

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta
	



func _on_area_entered(area: Area2D) -> void:
	var tm = area.get_node("Team")
	if tm.team_value != team:
		area.get_node("Damage_Module").damage(33,global_position)
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	print("HIT!")
	print(body)
	var tm = body.get_node("Team")
	if tm.team_value != team:
		body.get_node("Damage_Module").damage(33,global_position)
		queue_free()


func _on_timer_timeout() -> void:
	queue_free()
