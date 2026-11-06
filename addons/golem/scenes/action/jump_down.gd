# Jump down
extends ActionState

func _update(delta: float) -> void:
	if golem.velocity.y >= 0:
		transition("stand")
