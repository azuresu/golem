# Jump land
extends ActionState

@export var animation_land_start:= 0.2

func _update(delta: float) -> void:
	if _get_animation_percent() > animation_land_start:
		golem.move_to(Vector3.ZERO, 0)

func _on_animation_finished() -> void:
	transition("stand")
