extends CharacterBody2D


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

var max_speed := 600.0
# For this practice, we moved the direction vector outside the _physics_process() function.
# This allows the interactive practice to read its value and test if your code passes!
# You can access and change the direction variable inside the _physics_process() function as you did in the lesson.
var direction := Vector2(0, 0)


func _physics_process(_delta: float) -> void:
	# Set the direction from keyboard inputs here.
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction_discrete := direction.sign()

	match direction_discrete:
		Vector2.UP:
			print("67")
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
	# Set the velocity.
	velocity = direction * max_speed
	# Move the ship by calling the appropriate function from the CharacterBody2D node.
	
	if velocity.length() > 0.0:
		rotation = velocity.angle()
	move_and_slide()
