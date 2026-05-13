class_name Human extends Humanoid

@export var walk_speed:= 2.0
@export var walk: bool
@export var target_to_look: Node3D

func _ready() -> void:
	super._ready()
	if walk:
		animation_state_machine.set_current_state("walk")
	look_at_target(target_to_look)
