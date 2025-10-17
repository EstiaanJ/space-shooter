extends Node

@export var cooldown_time: float
#Direct effect stats
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
