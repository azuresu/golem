class_name GolemAgent extends Node3D

var golem: Golem

func get_target_to_look() -> Node3D:
	return null

func get_target_to_move() -> Node3D:
	return null

func is_acting(action_name: StringName) -> bool:
	return false
