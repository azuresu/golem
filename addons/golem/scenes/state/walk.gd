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
			golem.turn_to(target.global_position, deg_to_rad(golem.walk_turn_speed), delta)
			golem.move_to(target.global_position, golem.walk_speed)
