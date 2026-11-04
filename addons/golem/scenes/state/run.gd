class_name GolemState_Run extends GolemState

func _physics_update(delta: float) -> void:
	if golem.agent:
		var target_to_move:= golem.agent.target_to_move()
		if target_to_move:
			golem.move_to(target_to_move.global_position, golem.run_speed)
		var target_to_turn:= golem.agent.target_to_turn()
		if target_to_turn:
			golem.turn_to(target_to_turn.global_position, deg_to_rad(golem.run_turn_speed), delta)
