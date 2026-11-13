class_name GolemAgent extends Node3D

var golem: Golem:
	get: return golem if golem else get_parent()

func get_target_to_gaze() -> Node3D:
	return null

func get_target_to_move() -> Node3D:
	return null

func get_target_to_turn() -> Node3D:
	return get_target_to_move()

func get_state_to_act() -> StringName:
	return &""

func set_golem_velocity(v: Vector3) -> void:
	golem.velocity = v
