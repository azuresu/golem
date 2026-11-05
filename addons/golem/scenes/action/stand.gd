class_name ActionState_Stand extends ActionState

func _enter() -> void:
	golem.move_to(Vector3.ZERO, 0)
