extends Node3D

var human: Human:
	get: return get_parent()

func _process(delta: float) -> void:
	if human.position.y < -5:
		human.queue_free()

func _on_look_at_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		human.look_at_target(body)

func _on_look_at_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		human.look_at_target(null)
