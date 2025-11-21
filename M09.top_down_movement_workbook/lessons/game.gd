extends Node2D

@onready var _finish_line: FinishLine = %FinishLine
@onready var _runner: Runner = %Runner
@onready var _count_down: CountDown = %CountDown


func _ready():
	_runner.set_physics_process(false)
	_count_down.start_counting()
	_count_down.counting_finished.connect(func() -> void:
		_runner.set_physics_process(true)
	)
	_finish_line.body_entered.connect(func(body:Node) -> void:
		if (body is not Runner):
			return
		var runner := body as Runner
		runner.set_physics_process(false)
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
