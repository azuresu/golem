class_name GolemState_Stand extends GolemState

func _enter() -> void:
	golem.move_to(Vector3.ZERO, 0)

func _update(delta: float) -> void:
	if golem.agent:
		if golem.agent.is_moving():
			if golem.agent.is_acting("run"):
				transition("run")
			else:
				transition("walk")
