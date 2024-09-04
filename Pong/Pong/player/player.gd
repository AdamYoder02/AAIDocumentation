extends CharacterBody2D

var speed = 400
var lock_position

func _ready():
	lock_position = position.x

func _physics_process(delta):
	position.x = lock_position
	
	velocity = Vector2.ZERO
	if Input.is_action_pressed("Up"):
		velocity.y -= 1 * speed
	if Input.is_action_pressed("Down"):
		velocity.y += 1 * speed
	
	move_and_slide()
