extends CharacterBody2D
@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
@export var gravity=40
@export var jump_strength = 600.0

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "run"
		$AnimatedSprite2D.flip_v = false
		# See the note below about boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x < 0

func _physics_process(_delta):
	
	var horizontal_direction = Input.get_action_strength("ui_right") - Input.get_action_raw_strength("ui_left")

	velocity.x = horizontal_direction * speed
	velocity.y += gravity

	var is_falling = velocity.y > 0 and not is_on_floor()
	var is_jumping = velocity.y < 0 and not is_on_floor()
	var is_running = is_on_floor() and not is_zero_approx(velocity.x)
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y -= jump_strength

	if is_jumping:
		$AnimatedSprite2D.play("jump")
	elif is_falling:
		$AnimatedSprite2D.play("fall")
	elif is_running:
		$AnimatedSprite2D.play("run")
		$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		$AnimatedSprite2D.play("idle")
	move_and_slide()
	


