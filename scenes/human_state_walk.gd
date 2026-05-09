@tool
extends AnimationState

func _physics_process(delta: float) -> void:
	if not Engine.is_editor_hint():
		if golem.is_on_floor():
			var v: Vector3 = golem.get_model_vector() * golem.walk_speed
			golem.velocity = Vector3(v.x, golem.velocity.y, v.z)
		else:
			golem.velocity = Vector3(0, golem.velocity.y, 0)

func _exit() -> void:
	if not Engine.is_editor_hint():
		golem.velocity = Vector3(0, golem.velocity.y, 0)
