extends CharacterBody2D

@export var speed = 300
@export var thrust_power = 600.0  # Forward thrust strength
@export var rotation_speed = 3.0  # How fast the ship rotates
@export var max_speed = 200.0     # Maximum velocity
@export var drag = 0.95            # Air resistance (0.95 = more drag, 0.99 = less drag)

@onready var muzzle = $Muzzle 
@onready var shield_col = $ShieldCollider
@onready var damage_module = $Damage_Module
@onready var rifle_wp_module = $Rifle
@onready var shield_rad = shield_col.shape.radius


var shield_scene = preload("res://scenes/shield2.tscn")
var laser_scene = preload("res://scenes/laser.tscn")
var shoot_cd := false

signal laser_shot(laser_scene, location, rotation)
signal end_game



func _process(_delta):
	if damage_module.shield_points <= 0:
		shield_col.shape.radius = 0
	else:
		shield_col.shape.radius = shield_rad
	if Input.is_action_pressed("shoot"):
		var target_pos: Vector2 = Vector2.UP.rotated(rotation)
		rifle_wp_module.get_node("Weapon_Module").shoot(global_position,target_pos, "player_team")
		#if !shoot_cd:
		#	shoot_cd = true
		#	shoot()
		#	await get_tree().create_timer(0.2).timeout
		#	shoot_cd = false

func shoot():  
	laser_shot.emit(laser_scene,muzzle.global_position,rotation)


func _physics_process(delta: float) -> void:
	var rotation_input = Input.get_axis("turn_left", "turn_right")
	rotation += rotation_input * rotation_speed * delta
	var thrust_input = Input.get_axis("move_backward", "move_forward")
	if thrust_input != 0:
		var thrust_direction = Vector2.UP.rotated(rotation)
		velocity += thrust_direction * thrust_input * thrust_power * delta
	var strafe_input = Input.get_axis("move_left", "move_right")
	if strafe_input != 0:
		var strafe_direction = Vector2.RIGHT.rotated(rotation)
		velocity += strafe_direction * strafe_input * thrust_power * delta
	velocity *= drag
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed
	move_and_slide()


func _on_damage_module_no_hp() -> void:
	end_game.emit()


func _on_damage_module_shield_hit() -> void:
	var shield = shield_scene.instantiate()
	add_child(shield)
	
