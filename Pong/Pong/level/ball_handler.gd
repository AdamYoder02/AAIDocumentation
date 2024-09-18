extends Node

var ball_scene

func _ready():
	ball_scene = preload("res://ball/ball.tscn")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Spawn Ball"):
		_spawn_ball()

# create a new ball as a child of the ball handler node
func _spawn_ball():
	var new_ball = ball_scene.instantiate()
	new_ball.position.x = 345
	new_ball.position.y = 622
	add_child(new_ball)


func _on_timer_timeout() -> void:
	_spawn_ball()
