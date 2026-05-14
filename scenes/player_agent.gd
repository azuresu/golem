extends Node3D

@export var mouse_sensitivity:= 0.05
@export var human: Human

@onready var camera: Camera3D = $CameraArm/Camera

var _mouse_motion: Vector2

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_mouse_motion += event.relative

func _process(delta: float) -> void:
	rotation_degrees.y -= _mouse_motion.x * mouse_sensitivity
	camera.rotation_degrees.x = clampf(camera.rotation_degrees.x - _mouse_motion.y * mouse_sensitivity, -90, 90)
	_mouse_motion = Vector2.ZERO

func _physics_process(delta: float) -> void:
	var sprint = Input.is_action_pressed("sprint")
	if Input.is_action_pressed("move_forward"):
		human.turn_front($Forward.global_position, TAU, delta)
		human.set_animation("run" if sprint else "walk")
	elif Input.is_action_pressed("move_backward"):
		human.turn_front($Backward.global_position, TAU, delta)
		human.set_animation("run" if sprint else "walk")
	elif Input.is_action_pressed("move_left"):
		human.turn_front($Left.global_position, TAU, delta)
		human.set_animation("run" if sprint else "walk")
	elif Input.is_action_pressed("move_right"):
		human.turn_front($Right.global_position, TAU, delta)
		human.set_animation("run" if sprint else "walk")
	else:
		human.animation_state_machine.set_current_state("stand")
