extends CharacterBody2D

@onready var sprite := $Sprite2D
@onready var star := "res://Assets/star.png"

var disabled = false

var speed: int = 0
var minimum_speed: int = -400

var difficulty: float = 1

var radians: float = 0
var new_position: Vector2 = Vector2.ZERO

var wave_height: int = 100
var y_offset: int = 0

# x values
var wave_width: int = 1

# starting height
var wave_offset: int = 345

var ball_size: float = 1
var ball_rarity: int = 1
var ball_type: int = 1

var score: int = 100

# make a randomized "seed" for each new ball to randomize movement behavior
func _ready():
	var rng := RandomNumberGenerator.new()
	
	#small chance for rare balls
	ball_rarity = rng.randi_range(1, 100)
	
	# 1 > common  2 > uncommon  3 > rare  4 > legendary
	if ball_rarity >= 1 and ball_rarity < 50:
		ball_type = 1
	elif ball_rarity >= 50 and ball_rarity < 80:
		ball_type = 2
	elif ball_rarity >= 80 and ball_rarity < 99:
		ball_type = 3
	elif ball_rarity >= 99 and ball_rarity <= 100:
		ball_type = 4

	
	# change appearance for each rarity
	match ball_type:
		1:
			pass
		2:
			sprite.self_modulate = Color(0.5,0,1)
			score = 500
		3:
			sprite.self_modulate = Color(0,1,0)
			score = 1000
		4:
			var img = Image.new()
			img.load(star)
			sprite.texture = ImageTexture.create_from_image(img)
			sprite.scale.x = 0.25
			sprite.scale.y = 0.25
			score = 10000
		
	
	# randomize ball size
	ball_size = rng.randf_range(0.5, 1)

	var ball_size_vector := Vector2.ZERO
	ball_size_vector.x = ball_size
	ball_size_vector.y = ball_size
	scale = ball_size_vector
	
	# randomize wave height
	wave_height = rng.randi_range(200,300)

	# randomize radians start position
	radians = rng.randf_range(-1,1) * PI
	
	# randomize speed
	speed = rng.randi_range(-600,-400)
	
	# randomize difficulty
	difficulty = rng.randf_range(0.2,1)
	
	# ---------------------------------------------------------------------
	# set starting position
	position.x = 1315
	
	# viewport height is 720px, this position is the middle of the screen
	y_offset = 0
	# if wave height is smaller, y range is larger
	var y_range: int = 300 - wave_height
	
	#randomize starting y range within bounds
	y_range -= rng.randi_range(0,y_range)
	
	# y position is moved up or down by the random range value
	var direction_randomizer: Array = [-1,1]
	y_offset += y_range * direction_randomizer[randi() % 2]
	#print(y_offset)
	
	# set starting y position to new random value that ensures ball stays on screen
	position.y = y_offset
	#velocity = velocity * speed

func _radians_to_position(radians_input) -> float:
	var position_output = 0
	position_output = (sin(radians_input) * wave_height) + (wave_offset + y_offset)
	
	return position_output


func _process(delta):
	#turn off movement when caught
	if disabled:
		return
	
	if Input.is_action_just_pressed("Reset"):
		position.x = 644
		position.y = 345
		
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
	
	#print("Y: ", position.y)
	#print("X: ", position.x)
	#print("Rads: ", radians)
