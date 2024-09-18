extends Node


var score: int = 0

func _process(_delta: float) -> void:
	if score < 0:
		score = 0
