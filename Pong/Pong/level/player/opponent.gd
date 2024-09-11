extends CharacterBody2D

var speed = 400
var ball

var lock_position

func _ready():
	ball = get_parent().find_child("Ball")
	lock_position = position.x

func _physics_process(delta):
	position.x = lock_position
	velocity = Vector2(0,get_opponent_direction()) * speed
	move_and_slide()

func get_opponent_direction():
	if abs(ball.position.y - position.y) > 20:
		if ball.position.y > position.y: return 1
		else: return -1
	else: return 0
