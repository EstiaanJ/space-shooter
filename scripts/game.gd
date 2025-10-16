extends Node2D

@export var enemy_scenes: Array[PackedScene] = []

@onready var player_spawn_pos = $PlayerSpawnPos
@onready var laser_container = $LaserContainer
@onready var explosion_container = $ExplosionContainer
@onready var timer = $EnemySpawnTimer
@onready var enemy_container = $EnemyContainer
@onready var player = $Player
@onready var hp_bar = $CanvasLayer/Control/ProgressBar
#var player = null

func _ready():
	player = get_tree().get_first_node_in_group("player")
	assert(player != null)
	player.global_position = player_spawn_pos.global_position
	player.laser_shot.connect(_on_player_laser_shot)


func _process(delta: float) -> void:
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


func _on_enemy_spawn_timer_timeout() -> void:
	#return
	var e = enemy_scenes.pick_random().instantiate()
	e.global_position = Vector2(randf_range(-100,100),randf_range(-100,100));
	e.set_target(player)
	enemy_container.add_child(e)
