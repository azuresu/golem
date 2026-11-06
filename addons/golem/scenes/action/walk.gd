# Walk
extends ActionState

func _physics_update(delta: float) -> void:
	if golem.agent:
		var target_to_move:= golem.agent.target_to_move()
		if target_to_move:
			golem.move_to(target_to_move.global_position, _get_walk_speed())
		var target_to_turn:= golem.agent.target_to_turn()
		if target_to_turn:
			golem.turn_to(target_to_turn.global_position, deg_to_rad(_get_walk_turn_speed()), delta)

func _get_walk_speed() -> float:
	return golem.profile.walk_speed if golem.profile else 1.0

func _get_walk_turn_speed() -> float:
	return golem.profile.walk_turn_speed if golem.profile else 1.0
