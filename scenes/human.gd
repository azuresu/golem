@tool
class_name Human extends Humanoid

@export var walk_speed:= 2.0

func get_towards_vector() -> Vector3:
	return $Towards.global_position - global_position
