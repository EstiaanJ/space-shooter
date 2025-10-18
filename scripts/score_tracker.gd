extends Control

@onready var player_uuid = get_tree().root.get_node("Game/Player").uuid

var score: int = 0

func add_score(amount: float):
	#Check if game is over!
	score = score + int(amount)
