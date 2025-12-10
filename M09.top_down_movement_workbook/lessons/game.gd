extends Node2D

@onready var _finish_line: FinishLine = %FinishLine
@onready var _runner: Runner = %Runner
@onready var _count_down: CountDown = %CountDown
@onready var _bouncer: CharacterBody2D = %Bouncer


func _ready():
	_runner.set_physics_process(false)
	_bouncer.set_physics_process(false)
	_count_down.start_counting()
	_count_down.counting_finished.connect(func() -> void:
		_runner.set_physics_process(true)
		
	)
	_count_down.counting_finished.connect(func() -> void:
		await get_tree().create_timer(1.0).timeout
		var tween := create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
		_bouncer.set_physics_process(true)
		_bouncer.acceleration = 0.0
		tween.tween_property(_bouncer,"acceleration", 1200.0, 1.5)
		
	)
	_finish_line.body_entered.connect(func(body:Node) -> void:
		if (body is not Runner):
			return
		var runner := body as Runner
		runner.set_physics_process(false)
		_bouncer.set_physics_process(false)
		_bouncer.finish_line()
		var destination_point := (
			_finish_line.global_position 
			+ Vector2(0,_finish_line.area_height/2.0)
		)
		runner.walk_to(destination_point)
		runner.walked_to.connect(_finish_line.pop_confettis)
	)
	_finish_line.confettis_finished.connect(func()-> void:
		get_tree().reload_current_scene.call_deferred()
	)
