extends Timer

@export var initial_wait_time: float = 12.0
@export var min_wait_time: float = 0.2
@export var update_interval: float = 1.0  # Update wait_time every 5 seconds
@export var time_scale: float = 20  # Controls how fast the difficulty ramps up

var _time_elapsed: float = 0.0
var _update_timer: float = 0.0

func _ready() -> void:
	wait_time = initial_wait_time
	await get_tree().create_timer(0.5).timeout
	timeout.emit()

func _process(delta: float) -> void:
	_time_elapsed += delta
	_update_timer += delta
	
	# Update wait_time at fixed intervals
	if _update_timer >= update_interval:
		_update_timer = 0.0
		
		# Logarithmic decay formula: wait_time = min + (initial - min) / (1 + time/scale)
		var time_factor = _time_elapsed / time_scale
		var new_wait_time = min_wait_time + (initial_wait_time - min_wait_time) / (1.0 + time_factor)
		
		wait_time = new_wait_time
		print("Updated spawn interval: %.2f at time: %.1f" % [wait_time, _time_elapsed])

func _on_timeout() -> void:
	print("Enemy spawned! Current wait_time: %.2f" % wait_time)
