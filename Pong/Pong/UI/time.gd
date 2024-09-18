extends Label

@onready var timer := $Timer

func _process(delta: float) -> void:
	self.text = str(floor(timer.get_time_left()))
