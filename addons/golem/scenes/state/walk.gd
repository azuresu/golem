class_name GolemState_Walk extends GolemState

func _update(delta: float) -> void:
	if not _is_agent_moving():
		transition("stand")

func _physics_update(delta: float) -> void:
	var target:= golem.agent.get_target_to_move()
	if target:
		golem.turn_to(target.global_position, TAU, delta)
		golem.move_to(target.global_position, 1)
