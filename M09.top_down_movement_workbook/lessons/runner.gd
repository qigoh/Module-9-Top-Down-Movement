extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var max_speed := 600.0
@export var acceleration := 1200.0
@export var deceleration := 1080.0
@export var rotate_speed := 8.0
@onready var _runner_visual_red: RunnerVisual = %RunnerVisual


func _physics_process(delta: float) -> void:
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction.length() > 0.0:
		_runner_visual_red.angle = rotate_toward(_runner_visual_red.angle, direction.orthogonal().angle(), rotate_speed * delta)
	
	var is_move_input := direction.length() > 0.0
	
	if is_move_input:
		var desired_velocity := direction * max_speed
		velocity = velocity.move_toward(desired_velocity, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
	if (velocity.length() > 0.0):
		_runner_visual_red.animation_name = _runner_visual_red.Animations.WALK
		var current_speed_percent := velocity.length()/max_speed
		_runner_visual_red.animation_name = (
			RunnerVisual.Animations.WALK
			if current_speed_percent < 0.8
			else RunnerVisual.Animations.RUN
		)
	else:
		_runner_visual_red.animation_name = _runner_visual_red.Animations.IDLE
	#if direction:
		#pass
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
