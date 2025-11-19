class_name Runner extends CharacterBody2D



signal walked_to
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var max_speed := 600.0
@export var acceleration := 1200.0
@export var deceleration := 1080.0
@export var rotate_speed := 8.0
@onready var _runner_visual: RunnerVisual = %RunnerVisual
@onready var _dust: GPUParticles2D = %Dust
@onready var _dust_big: GPUParticles2D = %DustBig

func walk_to(destination_global_position:Vector2) -> void:
	var direction := global_position.direction_to(destination_global_position)
	_runner_visual.angle = direction.orthogonal().angle()
	var distance := global_position.distance_to(destination_global_position)
	var duration := distance/(max_speed* 0.2)
	_runner_visual.animation_name = RunnerVisual.Animations.WALK
	_dust.emitting = true
	_dust_big.emitting = true
	var tween:= create_tween()
	tween.tween_property(self, "global_position", destination_global_position, duration)
	tween.finished.connect(func () -> void:
		_runner_visual.animation_name = RunnerVisual.Animations.IDLE
		_dust.emitting = false
		_dust_big.emitting = false
		walked_to.emit())
	

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
		_runner_visual.angle = rotate_toward(_runner_visual.angle, direction.orthogonal().angle(), rotate_speed * delta)
	
	var is_move_input := direction.length() > 0.0
	
	if is_move_input:
		var desired_velocity := direction * max_speed
		velocity = velocity.move_toward(desired_velocity, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
	if (velocity.length() > 0.0):
		_dust.emitting = true
		_dust_big.emitting = true
		_runner_visual.animation_name = _runner_visual.Animations.WALK
		var current_speed_percent := velocity.length()/max_speed
		_runner_visual.animation_name = (
			RunnerVisual.Animations.WALK
			if current_speed_percent < 0.8
			else RunnerVisual.Animations.RUN
		)
	else:
		_dust_big.emitting = false
		_dust.emitting = false
		_runner_visual.animation_name = RunnerVisual.Animations.IDLE
	#if direction:
		#pass
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
