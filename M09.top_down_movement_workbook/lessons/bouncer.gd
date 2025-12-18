extends CharacterBody2D

signal walked_to
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var max_speed := 600.0
@export var acceleration := 1200.0
@export var avoidance_strength := 21000.0
@export var rotate_speed := 8.0

@onready var _runner_visual: RunnerVisual = %RunnerVisualPurple
@onready var _dust: GPUParticles2D = %Dust
@onready var _dust_big: GPUParticles2D = %DustBig
@onready var _hit_box: Area2D = $HitBox
@onready var _raycasts: Node2D = %Raycasts


func _ready() -> void:
	_hit_box.body_entered.connect(func(body: Node) -> void:
		if body is Runner:
			get_tree().reload_current_scene.call_deferred()
	)

func get_player_global_position() -> Vector2:
	return get_tree().root.get_node("Game/Runner").global_position

func finish_line() -> void:
	_runner_visual.animation_name = RunnerVisual.Animations.IDLE
	_dust.emitting = false
	_dust_big.emitting = false
	_hit_box.monitoring = false
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
	
func calculate_avoidance_force() -> Vector2:
	var avoidance_force := Vector2.ZERO
	for raycast: RayCast2D in _raycasts.get_children():
		if raycast.is_colliding():
			var collision_position := raycast.get_collision_point()
			var ray_length := raycast.target_position.length()
			var intensity := 1.0 - collision_position.distance_to(raycast.global_position)/ray_length
			var direction_away_from_obstacle := collision_position.direction_to(raycast.global_position)
			var force := direction_away_from_obstacle * intensity * avoidance_strength
			avoidance_force += force
	return avoidance_force

func _physics_process(delta: float) -> void:
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := global_position.direction_to(get_player_global_position())
	if direction.length() > 0.0:
		_runner_visual.angle = rotate_toward(_runner_visual.angle, direction.orthogonal().angle(), rotate_speed * delta)
		_raycasts.rotation = _runner_visual.angle
	
	
	var distance := global_position.distance_to(get_player_global_position())
	var speed := max_speed if distance > 100 else max_speed * distance/100
	var desired_velocity := direction * speed
	desired_velocity += calculate_avoidance_force() * delta
	velocity = velocity.move_toward(desired_velocity, acceleration * delta)
	if (velocity.length() > 10.0):
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
