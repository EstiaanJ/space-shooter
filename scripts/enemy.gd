class_name Enemy extends Area2D

@export var speed = 150
@export var start_health = 200
var health = start_health
#signal enemy_death_sig(location)
var explosion_scene = preload("res://scenes/enemy_death.tscn")
var plasma_hit = preload("res://scenes/plasma_hit.tscn")
var target: CharacterBody2D
var target_pos: Vector2
var laser_scene = preload("res://scenes/laser.tscn")
var shoot_cd := false
#signal laser_shot(laser_scene, location, rotation)


func _ready() -> void:
	health = start_health

func _physics_process(delta: float) -> void:
	if target:
		target_pos = target.global_position
		
func _process(delta: float) -> void:
	if target and target_pos:
		if !shoot_cd:
			shoot_cd = true
			shoot(target_pos)
			await get_tree().create_timer(1.15).timeout
			shoot_cd = false

func shoot(aim_point: Vector2):
	var target_bearing = global_position.angle_to_point(aim_point) + PI/2
	var shot = laser_scene.instantiate()
	shot.global_position = global_position
	shot.initialize(target_bearing,100,"enemy")
	get_tree().root.get_node("Game").add_child(shot)

func set_target(player_ref):
	target = player_ref
	print(target.global_position)
	

func _on_damage_module_no_hp() -> void:
	var explosion = explosion_scene.instantiate()
	explosion.global_position = global_position
	# Get the root game node instead of trying to find a child
	get_tree().root.get_node("Game").add_child(explosion)
	queue_free()
