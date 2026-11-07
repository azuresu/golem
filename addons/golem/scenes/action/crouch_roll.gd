# Roll
extends ActionState

@export var animation_roll_start:= 0.1
@export var animation_roll_end:= 0.9

func _update(delta: float) -> void:
	# Prevent from transition when rolling.
	pass

func _physics_update(delta: float) -> void:
	if golem.agent:
		var p:= _get_animation_percent()
		if p >= animation_roll_start and p < animation_roll_end:
			var target_to_move = golem.agent.target_to_move()
			if target_to_move:
				golem.move_to(target_to_move.global_position, _get_roll_speed())
		else:
			golem.move_to(Vector3.ZERO, 0)

func _on_animation_finished() -> void:
	transition("crouch")

func _get_roll_speed() -> float:
	var speed_max:= golem.profile.roll_speed if golem.profile else 1.0
	return sin(_get_animation_percent() * PI) * speed_max
