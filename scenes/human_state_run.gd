extends AnimationState

var human: Human:
	get: return owner

func get_speed_scale() -> float:
	return minf(update_time / 0.3, 1)

func _physics_update(delta: float) -> void:
	if human.is_on_floor():
		var f: Vector3 = human.get_front_vector() * human.walk_speed * get_speed_scale() * 3
		human.velocity = Vector3(f.x, human.velocity.y, f.z)
	else:
		human.velocity = Vector3(0, human.velocity.y, 0)

func _exit() -> void:
	human.velocity = Vector3(0, human.velocity.y, 0)
