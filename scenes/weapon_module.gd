extends Node
class_name Weapon_Module

#Direct effect stats
# Lasers deal direct damage to anything that occludes the beam or part of the beam, but can deal AOE damage surrounding the beam
# For lasers the damage amount is DPS not one shot.
@export var sp_damage_direct: float
@export var ap_damage_direct: float 
@export var hp_damage_direct: float
@export var ap_pen_direct: float
#AOE effect stats
@export var ap_damage_aoe: float 
@export var hp_damage_aoe: float
@export var ap_pen_aoe = 0.0

@export var projectile_speed: float # -1 means instant, like for laser
@export var projectile_turnrate: float # For guided projectiles, missiles

@export var trigger_rad = 0.0 # for exploding near an enemy, like missiles and flak

@export var shield_bypass = false

@export var projectile: Projectile

@onready var owner_UUID: String
@onready var cd_timer: Timer = $CooldownTimer


func shoot(target: Vector2) -> void:
	if cd_timer.timeout:
		cd_timer.start()
		#projectile.initialize()
		
		

			
#	var target_bearing = global_position.angle_to_point(aim_point) + PI/2
#	var shot = laser_scene.instantiate()
#	shot.global_position = global_position
#	shot.initialize(target_bearing,100,"enemy")
#	get_tree().root.get_node("Game").add_child(shot)
