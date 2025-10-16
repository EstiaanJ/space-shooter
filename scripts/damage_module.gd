extends Node

@export var max_hull_points: float
@export var armour_points: float
@export var shield_points_init: float
@export var sp_regen_rate: float

@onready var hull_points = max_hull_points
@onready  var shield_points = shield_points_init
var plasma_hit = preload("res://scenes/plasma_hit.tscn")
signal no_hp


func _process(delta: float) -> void:
	if shield_points < 0:
		shield_points = 0
	shield_points += (sp_regen_rate * delta)
	if shield_points > shield_points_init:
		shield_points = shield_points_init

func damage(amount: float, location: Vector2) -> void:
	var damage_remaining = amount
	var sp_damage = 0
	var ap_damage = 0
	var hp_damage = 0
	
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
			else:
				print("KILL")	
				#var explosion = explosion_scene.instantiate()
				#explosion.global_position = global_position
				#get_tree().root.get_node("Game").add_child(explosion)
				no_hp.emit()
				#KILL
	hull_points = hull_points - hp_damage
	armour_points = armour_points - ap_damage
	shield_points= shield_points - sp_damage

	print("<HIT> HP: " + str(hull_points) + "  | AP: " + str(armour_points) + "  | SP: " + str(shield_points) )
	var plasmaHit = plasma_hit.instantiate()
	plasmaHit.global_position = location
	get_tree().root.get_node("Game").add_child(plasmaHit)
