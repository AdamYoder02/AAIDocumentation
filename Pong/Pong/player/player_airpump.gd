extends CharacterBody2D

var impulse = 500
var pump_strength = 150
var boost = 0
var speed = 100
var max_speed = -500

var gravity = 1200
var max_gravity = 500
var lock_position

var air_particles

func _ready():
	lock_position = position.x
	velocity = Vector2.ZERO
	
	air_particles = get_node("Particles")

func _physics_process(delta):
	position.x = lock_position
	
	if Input.is_action_just_pressed("Up"):
		velocity.y -= impulse
		print("just pressed")
	if Input.is_action_pressed("Up"):
		air_particles.emitting = true
		
		boost += pump_strength * delta
		velocity.y -= boost * speed * delta

	else:
		if Input.is_action_just_released("Up"):
			boost = 0
			air_particles.emitting = false
	
	velocity.y += gravity * delta
	if velocity.y >= max_gravity:
		velocity.y = max_gravity
		
	if velocity.y <= max_speed:
		velocity.y = max_speed
	
	print("Velocity: ", velocity.y)
	print("Boost: ", boost)
	
	move_and_slide()
