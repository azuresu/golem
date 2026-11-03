class_name GolemState_Stand extends GolemState

func _enter() -> void:
	golem.velocity.x = 0
	golem.velocity.z = 0

func _update(delta: float) -> void:
	if _is_agent_moving():
		transition("walk")
