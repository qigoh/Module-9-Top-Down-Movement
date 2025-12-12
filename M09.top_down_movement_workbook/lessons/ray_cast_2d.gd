extends RayCast2D

func _physics_process(delta: float) -> void:
	global_position = get_global_mouse_position()
	if is_colliding():
		print(get_collision_point())
