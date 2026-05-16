extends Node3D

var cooldown_max:= 0.5
var cooldown: float

func can_fire() -> bool:
	return cooldown == 0

func fire(target_position: Vector3) -> void:
	cooldown = cooldown_max
	var flying = Glaze.new_scene("res://scenes/fire_axe_flying.tscn", get_tree().get_first_node_in_group("stage"))
	flying.throw(global_position, target_position, 9, 1.5)

func _ready() -> void:
	%PitchOffset.rotation_degrees.x = randf_range(0, 360)

func _process(delta: float) -> void:
	var c = cooldown
	cooldown = maxf(0, cooldown - delta)
	if c > 0 and cooldown == 0:
		%PitchOffset.rotation_degrees.x = randf_range(0, 360)
	visible = cooldown == 0
