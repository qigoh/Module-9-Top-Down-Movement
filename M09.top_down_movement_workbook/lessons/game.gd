extends Node2D

@onready var _finish_line: FinishLine = %FinishLine


func _ready():
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
