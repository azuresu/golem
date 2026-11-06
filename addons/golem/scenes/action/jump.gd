# Jump
extends ActionState

@export var init_velocity_scale:= 2.0
@export var animation_jump_start:= 0.6

var _jumped: bool
var _velocity: Vector3

func _enter() -> void:
	_jumped = false
	_velocity = golem.velocity * init_velocity_scale
	golem.move_to(Vector3.ZERO, 0)

func _update(delta: float) -> void:
	if _get_animation_percent() >= animation_jump_start:
		if not _jumped:
			golem.velocity = Vector3(_velocity.x, _get_jump_speed(), _velocity.z)
			_jumped = true

	if _jumped and golem.velocity.y < 0:
		transition("jump_land")

func _get_jump_speed() -> float:
	return golem.profile.jump_speed if golem.profile else 1.0
