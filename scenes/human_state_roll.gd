extends AnimationState

func get_speed_scale() -> float:
	return minf(update_time / 0.3, 1)

func _physics_update(delta: float) -> void:
	if golem.is_on_floor():
		var f: Vector3 = golem.get_front_vector() * golem.walk_speed * get_speed_scale() * 3
		golem.velocity = Vector3(f.x, golem.velocity.y, f.z)
	else:
		golem.velocity = Vector3(0, golem.velocity.y, 0)

func _exit() -> void:
	golem.velocity = Vector3(0, golem.velocity.y, 0)
