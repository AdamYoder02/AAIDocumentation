extends CharacterBody2D

var speed = 400

func _ready():
	velocity.x = [-1,1][randi() % 2]
	velocity.y = [-0.8,0.8][randi() % 2]
	
	#velocity = velocity * speed
	
func _physics_process(delta):
	var collisionObject = move_and_collide(velocity * speed * delta)
	if collisionObject:
		velocity = velocity.bounce(collisionObject.get_normal())

func _process(delta):
	if Input.is_action_just_pressed("Reset"):
		velocity.x = [-1,1][randi() % 2]
		velocity.y = [-0.8,0.8][randi() % 2]
		
		position.x = 644
		position.y = 345

func _on_left_body_entered(body):
	velocity.x = [-1,1][randi() % 2]
	velocity.y = [-0.8,0.8][randi() % 2]
