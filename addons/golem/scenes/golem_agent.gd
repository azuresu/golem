class_name GolemAgent extends Node3D

var golem: Golem:
	get: return golem if golem else get_parent()

func target_to_gaze() -> Node3D:
	return null

func target_to_move() -> Node3D:
	return null

func target_to_turn() -> Node3D:
	return target_to_move()

func state_to_act() -> StringName:
	return &""
