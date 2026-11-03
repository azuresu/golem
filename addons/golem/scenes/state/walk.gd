class_name GolemState_Walk extends GolemState

func _update(delta: float) -> void:
	if golem.agent:
		if not golem.agent.is_moving():
			transition("stand")
		elif golem.agent.is_acting("run"):
			transition("run")

func _physics_update(delta: float) -> void:
	if golem.agent:
		var target:= golem.agent.get_target_to_move()
		if target:
			golem.turn_to(target.global_position, TAU, delta)
			golem.move_to(target.global_position, 1)
