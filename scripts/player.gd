extends CharacterBody2D

@export var speed = 300
@export var thrust_power = 600.0  # Forward thrust strength
@export var rotation_speed = 3.0  # How fast the ship rotates
@export var max_speed = 200.0     # Maximum velocity
@export var drag = 0.95            # Air resistance (0.95 = more drag, 0.99 = less drag)

@onready var muzzle = $Muzzle 

var laser_scene = preload("res://scenes/laser.tscn")
var shoot_cd := false

signal laser_shot(laser_scene, location, rotation)

#func _ready():
	#set_notify_transform(false)


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
	# Rotation input (left/right)
	var rotation_input = Input.get_axis("turn_left", "turn_right")
	rotation += rotation_input * rotation_speed * delta
	
	# Forward thrust input
	var thrust_input = Input.get_axis("move_backward", "move_forward")
	
	if thrust_input != 0:
		# Apply thrust in the direction the ship is facing
		var thrust_direction = Vector2.UP.rotated(rotation)
		velocity += thrust_direction * thrust_input * thrust_power * delta
	
	# Strafe input (left/right movement)
	var strafe_input = Input.get_axis("move_left", "move_right")
	
	if strafe_input != 0:
		# Apply strafe thrust perpendicular to facing direction
		var strafe_direction = Vector2.RIGHT.rotated(rotation)
		velocity += strafe_direction * strafe_input * thrust_power * delta
	
	# Apply drag to simulate space friction
	velocity *= drag
	
	# Clamp to max speed
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed
	
	move_and_slide()


func _on_damage_module_no_hp() -> void:
	queue_free()
