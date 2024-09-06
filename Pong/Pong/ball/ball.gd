extends CharacterBody2D

var speed: int = 100
var difficulty: int = 1

var radians: float = 0
var new_position: Vector2 = Vector2.ZERO

# randomize y value range
var wave_height_array = [300,250,200,150,100,50]
var wave_height: int = wave_height_array[randi() % wave_height_array.size()]

# x values
var wave_width: int = 1

# starting height
var wave_offset: int = 345

func _ready():
	position.x = 622
	position.y = 345
	
	# randomize radians start position
	var radians_array = [-1,-0.8,-0.6,-0.4,-0.2,0,0.2,0.4,0.6,0.8,1]
	for n in radians_array.size():
		radians_array[n] = radians_array[n] * PI
		print(radians_array[n])
	
	radians = radians_array[randi() % radians_array.size()]
	
	#randomize speed
	var speed_array = [-100,-80,-60,-40,40,60,80,100]
	speed = speed_array[randi() % speed_array.size()]
	
	#velocity = velocity * speed

func _radians_to_position(radians_input) -> float:
	var position_output = 0
	position_output = (sin(radians_input) * wave_height) + wave_offset
	
	return position_output
	
	
func _physics_process(delta):

	#print("Y: ", position.y)
	#print("X: ", position.x)
	#print("Rads: ", radians)
	
	#set new position x value based on speed
	new_position.x = position.x + (speed * delta)
	
	# update radians based on difficulty value
	radians += difficulty * delta
	
	# set new position y value to sin position
	new_position.y = _radians_to_position(radians)
	position.y = new_position.y
	position.x = new_position.x
	
	# clear new position variable for next frame
	new_position = Vector2.ZERO

func _process(delta):
	if Input.is_action_just_pressed("Reset"):
		velocity.x = [-1,1][randi() % 2]
		velocity.y = [-0.8,0.8][randi() % 2]
		
		position.x = 644
		position.y = 345
