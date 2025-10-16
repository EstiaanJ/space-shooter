extends Node2D

@export var enemy_scenes: Array[PackedScene] = []

@onready var player_spawn_pos = $PlayerSpawnPos
@onready var laser_container = $LaserContainer
@onready var explosion_container = $ExplosionContainer
@onready var timer = $EnemySpawnTimer
@onready var enemy_container = $EnemyContainer
@onready var player = $Player
@onready var hp_bar = $CanvasLayer/Control/HPBar
@onready var sp_bar = $CanvasLayer/Control/SPBar
@onready var ap_bar = $CanvasLayer/Control/APBar
@onready var enemy_count_label = $CanvasLayer/Control/EnemyCnt
@onready var time_score = $CanvasLayer/Control/TimeScore
var enemy_count = 0
#var player = null

func _ready():
	player = get_tree().get_first_node_in_group("player")
	assert(player != null)
	player.global_position = player_spawn_pos.global_position
	player.laser_shot.connect(_on_player_laser_shot)


func _process(delta: float) -> void:
	enemy_count = enemy_container.get_child_count()
	enemy_count_label.text = "Enemies: " + str(enemy_count)
	time_score.text = "Time: " + str(float(Time.get_ticks_msec()/1000.0))
	update_player_health()
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()

func _on_player_laser_shot(laser_scene, location, direction):
	var laser = laser_scene.instantiate()
	laser.global_position = location
	laser.initialize(direction,350,"player_team") 
	laser_container.add_child(laser)

func update_player_health() -> void:
	var hp = player.get_node("Damage_Module").hull_points
	var max_hp = player.get_node("Damage_Module").max_hull_points
	hp_bar.value = (hp/max_hp)*100
	
	var sp = player.get_node("Damage_Module").shield_points
	var max_sp = player.get_node("Damage_Module").max_shield_points
	sp_bar.value = (sp/max_sp)*100
	
	var ap = player.get_node("Damage_Module").armour_points
	var max_ap = player.get_node("Damage_Module").max_armour_points
	ap_bar.value = (ap/max_ap)*100


func _on_enemy_spawn_timer_timeout() -> void:
	#return
	var e = enemy_scenes.pick_random().instantiate()
	e.global_position = Vector2(randf_range(-1000,1000),randf_range(-1000,1000));
	e.set_target(player)
	enemy_container.add_child(e)


func _on_player_end_game() -> void:
	var death_time = Time.get_ticks_msec()
	time_score = death_time
	enemy_count = "Game Over"
	get_tree().paused = true
	#get_tree().reload_current_scene()
