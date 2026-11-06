# Run jump
extends ActionState

@export var init_velocity_scale:= 1.5

func _enter() -> void:
	var v:= golem.velocity * init_velocity_scale
	golem.velocity = Vector3(v.x, _get_jump_speed(), v.z)

func _update(delta: float) -> void:
	pass

func _physics_update(delta: float) -> void:
	if golem.velocity.y < 0:
		transition("run_jump_land")

func _get_jump_speed() -> float:
	return golem.profile.jump_speed if golem.profile else 1.0
