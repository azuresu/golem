extends AnimationState

func _enter() -> void:
	golem.velocity = Vector3(0, golem.velocity.y, 0)
