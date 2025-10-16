extends CharacterBody2D

@export var speed = 300
@export var thrust_power = 600.0  # Forward thrust strength
@export var rotation_speed = 3.0  # How fast the ship rotates
@export var max_speed = 200.0     # Maximum velocity
@export var drag = 0.95            # Air resistance (0.95 = more drag, 0.99 = less drag)
@export var animation_tree : AnimationTree
@export var playback : AnimationNodeStateMachinePlayback

@onready var muzzle = $Muzzle 

var laser_scene = preload("res://scenes/laser.tscn")
var shoot_cd := false

signal laser_shot(laser_scene, location, rotation)

func _ready():
	playback = animation_tree["parameters/playback"]


func _process(delta):
	if Input.is_action_pressed("shoot"):
		if !shoot_cd:
			shoot_cd = true
			shoot()
			await get_tree().create_timer(0.2).timeout
			shoot_cd = false

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
	select_animation()
	update_sprite_dir(rotation)

func select_animation() -> void:
	playback.travel("BlendSpace2D")

func update_sprite_dir(rot: float) -> void:
	var dirVec: Vector2 = Vector2.from_angle(-(rot - PI/2)).normalized()
	print(dirVec)
	animation_tree["parameters/BlendSpace2D/blend_position"] = dirVec



func _on_damage_module_no_hp() -> void:
	queue_free()
