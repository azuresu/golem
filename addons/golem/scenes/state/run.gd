class_name GolemState_Run extends GolemState

func _update(delta: float) -> void:
	if golem.agent:
		if not golem.agent.is_moving():
			transition("stand")
		elif not golem.agent.is_acting("run"):
			transition("walk")

func _physics_update(delta: float) -> void:
	if golem.agent:
		var target:= golem.agent.get_target_to_move()
		if target:
			golem.turn_to(target.global_position, deg_to_rad(golem.run_turn_speed), delta)
			golem.move_to(target.global_position, golem.run_speed)
