extends CharacterBody2D

signal state_changed(state)

@export_range(300, 1000) var speed: float = 400
@export_range(10, 300) var mouse_speed: float = 100
@export_range(1, 10) var minimum_mouse_motion = 10
var mouse_velocity: Vector2 = Vector2.ZERO


var lock_position: float

var fish_on_hook

# character states
enum States {IDLE, MOVING, CATCHING, CAUGHT, THROWING}
# start idle state
var state: States = States.IDLE
var is_fish_caught := false

func _ready():
	lock_position = position.x
	Input.mouse_mode = 2

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
	
	_keyboard_input()
	_input(Input.MOUSE_MODE_CAPTURED)
	mouse_velocity = Vector2.ZERO
	
	if state in [States.IDLE, States.MOVING]:
		move_and_slide()
	
	position.x = lock_position

func _keyboard_input():
	if Input.is_action_pressed("Up") or Input.is_action_just_released("Up"):
		velocity.y -= 1 * speed
	elif Input.is_action_pressed("Down") or Input.is_action_just_released("Down"):
		velocity.y += 1 * speed

func _input(event):
	if event is InputEventMouseMotion:
		mouse_velocity = event.get_screen_relative()
		#print("Mouse Input Captured")
	
	velocity.y += mouse_velocity.y * mouse_speed

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
