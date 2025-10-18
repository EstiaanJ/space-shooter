extends Node
class_name Damage_Module

@export var max_hull_points: float
@export var max_shield_points: float
@export var max_armour_points: float
@export var sp_regen_rate: float

@onready var hull_points = max_hull_points
@onready var shield_points = max_shield_points
@onready var armour_points = max_armour_points
@onready var charge_timer = $ChargeTimer
var plasma_hit = preload("res://scenes/plasma_hit.tscn")
signal no_hp
signal damage_taken
signal shield_hit


func _process(delta: float) -> void:
	if shield_points < 0:
		shield_points = 0
	if charge_timer.is_stopped(): 
		shield_points += (sp_regen_rate * delta)
	if shield_points > max_shield_points:
		shield_points = max_shield_points

func damage(amount: float, location: Vector2) -> float:
	var damage_remaining = amount
	var sp_damage = 0
	var ap_damage = 0
	var hp_damage = 0
	var score = 0
	charge_timer.start()
	if shield_points > 0:
		shield_hit.emit()
	sp_damage = damage_remaining
	damage_remaining = damage_remaining - shield_points
	if damage_remaining > 0:
		sp_damage = shield_points
		ap_damage = damage_remaining
		damage_remaining = damage_remaining - armour_points
		if damage_remaining > 0:
			ap_damage = armour_points
			if damage_remaining < hull_points:
				hp_damage = damage_remaining
				score = hp_damage
			else:
				score = hull_points
				no_hp.emit()
	hull_points = hull_points - hp_damage
	armour_points = armour_points - ap_damage
	shield_points= shield_points - sp_damage
	var plasmaHit = plasma_hit.instantiate()
	plasmaHit.global_position = location #TODO: Move this!
	if get_tree():
		get_tree().root.get_node("Game").add_child(plasmaHit)
	return score
