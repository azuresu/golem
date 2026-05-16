extends Node3D

@export var mouse_sensitivity:= 0.05
@export var human: Human

@onready var arm: SpringArm3D = $CameraArm
@onready var camera: Camera3D = $CameraArm/Camera

var _mouse_motion: Vector2

func set_player(player: Human) -> void:
	global_rotation = player.global_rotation
	arm.add_excluded_object(player)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_mouse_motion += event.relative

func _process(delta: float) -> void:
	rotation_degrees.y -= _mouse_motion.x * mouse_sensitivity
	arm.rotation_degrees.x = clampf(arm.rotation_degrees.x - _mouse_motion.y * mouse_sensitivity, -90, 90)
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

	var player: Human = get_tree().get_first_node_in_group("player")
	var pri_weapon = player.get_node("Primary").get_child(0)
	if Input.is_action_pressed("primary_attack") and pri_weapon and pri_weapon.can_fire():
		pri_weapon.fire(_get_aim_position())
	var sec_weapon = player.get_node("Secondary").get_child(0)
	if Input.is_action_pressed("secondary_attack") and sec_weapon and sec_weapon.can_fire():
		sec_weapon.fire(_get_aim_position())

func _get_aim_position() -> Vector3:
	if %AimCast.is_colliding():
		return %AimCast.get_collision_point()
	return %AimDefault.global_position
