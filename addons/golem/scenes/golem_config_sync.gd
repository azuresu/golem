@tool
extends Node

@export var state_machine: StateMachine

func _process(delta: float) -> void:
	if owner.config:
		owner.config.state_machine = state_machine
