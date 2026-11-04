class_name GolemState_Stand extends GolemState

func _enter() -> void:
	golem.move_to(Vector3.ZERO, 0)
