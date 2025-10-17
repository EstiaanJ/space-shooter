extends Label

@onready var player = $".."

func _process(_delta: float) -> void:
	var y = int(player.global_position.y)
	var x = int(player.global_position.x)
	text = "X: " + str(x) + "\nY: " + str(y)
