extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var max_speed := 600.0
@onready var _skin: Sprite2D = %Skin
const RUNNER_DOWN = preload("uid://c0i1ik45p7rhh")

const RUNNER_DOWN_RIGHT = preload("uid://cst3aklarj68")

const RUNNER_RIGHT = preload("uid://b4etxv4c5w1mq")
const RUNNER_UP = preload("uid://dtrvq16cx035")
const RUNNER_UP_RIGHT = preload("uid://c7x3s5c2r5l86")

const UP_RIGHT := Vector2.UP + Vector2.RIGHT
const DOWN_RIGHT := Vector2.DOWN + Vector2.RIGHT
const UP_LEFT := Vector2.UP + Vector2.LEFT
const DOWN_LEFT := Vector2.DOWN + Vector2.LEFT

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction_discrete := direction.sign()

	match direction_discrete:
		Vector2.UP:
			_skin.texture = RUNNER_UP
		Vector2.DOWN:
			_skin.texture = RUNNER_DOWN
		Vector2.RIGHT, Vector2.LEFT:
			_skin.texture = RUNNER_RIGHT
		UP_RIGHT, UP_LEFT:
			_skin.texture = RUNNER_UP_RIGHT
		DOWN_RIGHT, DOWN_LEFT:
			_skin.texture = RUNNER_DOWN_RIGHT
	
	if direction_discrete.length() > 0.0:
		_skin.flip_h = direction.x < 0.0
	velocity = direction * max_speed
	#if direction:
		#pass
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
