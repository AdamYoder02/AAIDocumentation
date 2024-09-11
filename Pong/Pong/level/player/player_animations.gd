extends AnimationPlayer


func _on_player_state_changed(state: Variant) -> void:
	if state == "stop":
		stop()
	else:
		play(state)
