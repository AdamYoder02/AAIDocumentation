extends CharacterBody2D

var speed = 400
var lock_position

var mouse_position = Vector2.ZERO

var fish_caught = true

func _ready():
	lock_position = position.x
	
func _input(event):
	if event is InputEventMouseMotion:
		mouse_position = event.position

func _process(delta):
	if Input.is_action_just_pressed("Throw") && fish_caught == true:
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


func _on_player_detection_body_entered(body: Node2D) -> void:
	body.position.x = position.x
	body.position.y = position.y
	body.queue_free()
