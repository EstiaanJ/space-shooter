class_name EnemyShip extends Area2D

@export var speed = 150
@export var start_health = 200
var health = start_health
signal enemy_death_sig(location)
var explosion_scene = preload("res://scenes/enemy_death.tscn")
var plasma_hit = preload("res://scenes/plasma_hit.tscn")
var target: CharacterBody2D
var target_pos: Vector2
var laser_scene = preload("res://scenes/laser.tscn")
var shoot_cd := false
signal laser_shot(laser_scene, location, rotation)

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
			await get_tree().create_timer(0.7).timeout
			shoot_cd = false

func damage(amount: float, location: Vector2) -> void:
	health = health - amount
	var plasmaHit = plasma_hit.instantiate()
	plasmaHit.global_position = location
	get_tree().root.get_node("Game").add_child(plasmaHit)
	if health < 0 :
		print("DEATH")
		var explosion = explosion_scene.instantiate()
		explosion.global_position = global_position
		# Get the root game node instead of trying to find a child
		get_tree().root.get_node("Game").add_child(explosion)
		queue_free()

func shoot(aim_point: Vector2):
	var target_bearing = global_position.angle_to_point(aim_point)
	laser_shot.emit(laser_scene, global_position, target_bearing)

func set_target(player_ref):
	target = player_ref
