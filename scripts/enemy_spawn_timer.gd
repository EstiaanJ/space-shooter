extends Timer

@export var min_wait_time: float = 0.75
@export var decrease_amount: float = 0.4
@export var decrease_interval: float = 5.0  # how often to make it faster (in seconds)

var _time_elapsed: float = 0.0
var _decrease_timer: float = 0.0

func _ready() -> void:
	await get_tree().create_timer(0.5).timeout
	timeout.emit()

func _process(delta: float) -> void:
	_time_elapsed += delta
	_decrease_timer += delta

	# Every `decrease_interval` seconds, decrease wait_time a bit
	if _decrease_timer >= decrease_interval:
		_decrease_timer = 0.0
		if wait_time > min_wait_time:
			wait_time = max(wait_time - decrease_amount, min_wait_time)
			print("New spawn interval: ", wait_time)

func _on_timeout() -> void:
	print("Timer timeout! Current wait_time: ", wait_time)
