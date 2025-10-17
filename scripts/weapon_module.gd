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

@export var cd_time = 0.5
@export var projectile_scene: PackedScene

@onready var owner_UUID: String
#@onready var plasma_scene = preload("res://scenes/player_plasma_shot.tscn")

var cd_flag := false

func shoot(source: Vector2, target: Vector2, team: String) -> void:
	if !cd_flag:
			cd_flag = true
			var target_bearing = source.angle_to_point(target) #Probably not needed anymore
			var plasma = projectile_scene.instantiate()
			plasma.global_position = source
			plasma.initialize(target, projectile_speed, team, self) #func initialize(rot: float, speedIn: float, creatorIn: String, owmIn: Weapon_Module) -> void:
			plasma.speed = projectile_speed
			get_tree().root.get_node("Game").add_child(plasma)
			await get_tree().create_timer(cd_time).timeout
			cd_flag = false
