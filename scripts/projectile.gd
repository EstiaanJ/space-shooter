extends Area2D
class_name Projectile

var speed: float
var direction: Vector2 = Vector2.UP
var team: String
var origin_weapon_module: Weapon_Module

func initialize(target: Vector2, speedIn: float, creatorIn: String, owmIn: Weapon_Module) -> void:
	speed = speedIn
	rotation = target.angle() + PI/2
	direction = target.normalized()
	team = creatorIn
	origin_weapon_module = owmIn.duplicate()

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta
	
func execute_damage(damage_module: Damage_Module) -> void:
	damage_module.damage(origin_weapon_module.hp_damage_direct,global_position)
	queue_free()

func _on_timer_timeout() -> void:
	queue_free()



func _on_area_entered(area: Area2D) -> void:
	var tm = area.get_node("Team").team_value 
	if tm != team:
		execute_damage(area.get_node("Damage_Module"))


func _on_body_entered(body: Node2D) -> void:
	var tm = body.get_node("Team").team_value
	if tm != team:
		execute_damage(body.get_node("Damage_Module"))
