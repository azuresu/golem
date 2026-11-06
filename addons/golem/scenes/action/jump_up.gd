# Jump up
extends ActionState

var _animation_up: bool

func _enter() -> void:
	_animation_up = false
	golem.move_to(Vector3.ZERO, 0)

func _update(delta: float) -> void:
	if _get_animation_percent() >= 0.7 and not _animation_up:
		_animation_up = true
		golem.velocity = Vector3(golem.velocity.x, _get_jump_speed(), golem.velocity.z)

	if _animation_up and golem.velocity.y <= 0:
		transition("jump_down")

func _get_jump_speed() -> float:
	return golem.profile.jump_speed if golem.profile else 1.0
