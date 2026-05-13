extends AnimationState

func _physics_update(delta: float) -> void:
	if golem.is_on_floor():
		var v: Vector3 = golem.get_towards_vector() * golem.walk_speed
		golem.velocity = Vector3(v.x, golem.velocity.y, v.z)
	else:
		golem.velocity = Vector3(0, golem.velocity.y, 0)

func _exit() -> void:
	golem.velocity = Vector3(0, golem.velocity.y, 0)
