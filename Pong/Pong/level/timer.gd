extends Timer

var time: float = 0.3
var timer_array: Array = [0.1,0.2,0.3,0.4,0.5]

func _ready() -> void:
	time = timer_array[randi() % timer_array.size()]

# randomize time to spawn a new ball on timeout of last timer
func _on_timeout() -> void:
	wait_time = _new_time()
	#print(wait_time)

func _new_time() -> float:
	return timer_array[randi() % timer_array.size()]
