extends CharacterBody2D

signal state_changed(state)

var speed: float = 400
var lock_position: float

var fish_on_hook

# character states
enum States {IDLE, MOVING, CATCHING, CAUGHT, THROWING}
# start idle state
var state: States = States.IDLE
var is_fish_caught := false

func _ready():
	lock_position = position.x

func _physics_process(delta: float) -> void:
	
	
	# if fish is caught set state
	if state == States.CAUGHT:
		state_changed.emit("caught_animation")
		#print("CAUGHT")
	# if paddle is moving set state
	elif velocity.y == 0 and state in [States.IDLE, States.MOVING]:
		state = States.IDLE
		#print("IDLE")
	elif velocity.y != 0 and state in [States.IDLE, States.MOVING]:
		state = States.MOVING
		#print("MOVING")
	
	# start throwing fish if it is caught
	if Input.is_action_just_pressed("Throw") and state == States.CAUGHT:
		state = States.THROWING
		state_changed.emit("throwing_animation")
		# add score when a fish is caught
		Global.score += fish_on_hook.score
		
	
	velocity = Vector2.ZERO
	if Input.is_action_pressed("Up"):
		velocity.y -= 1 * speed
	if Input.is_action_pressed("Down"):
		velocity.y += 1 * speed
	
	if state in [States.IDLE, States.MOVING]:
		move_and_slide()
	
	position.x = lock_position

# detects when a ball hits the paddle
func _on_player_detection_body_entered(body: Node2D) -> void:
	if state in [States.IDLE, States.MOVING] and body.get_parent() == $"../Ball Handler":
		fish_on_hook = body
		state = States.CAUGHT
		#print("FISH DETECTED")
		body.reparent(self)
		body.disabled = true

func _delete_ball() -> void:
	var ball = get_child(get_child_count()-1)
	ball.queue_free()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "throwing_animation":
		$Timer.start(0.2)
		#position.y = 316


func _on_timer_timeout() -> void:
	state = States.IDLE
