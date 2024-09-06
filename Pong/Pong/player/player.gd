extends CharacterBody2D

var speed: float = 400
var lock_position: float

var mouse_position: Vector2 = Vector2.ZERO

var fish_on_hook: bool = true
var fish_caught: bool = false

func _ready():
	lock_position = position.x
	
func _input(event):
	if event is InputEventMouseMotion:
		mouse_position = event.position

func _process(delta):
	if Input.is_action_just_pressed("Throw") && fish_on_hook == true:
		print("Throw fish")

func _physics_process(delta):
	position.x = lock_position
	
	# position.y = mouse_position.y
	
	velocity = Vector2.ZERO
	if Input.is_action_pressed("Up"):
		velocity.y -= 1 * speed
	if Input.is_action_pressed("Down"):
		velocity.y += 1 * speed
	
	move_and_slide()

# detects when a ball hits the paddle
func _on_player_detection_body_entered(body: Node2D) -> void:
	body.position.x = position.x
	body.position.y = position.y
	body.queue_free()
	print("Player hits ball")
