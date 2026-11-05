extends PlayerAgent

var _gazed_golem: Golem

func _on_gaze_area_body_entered(body: Node3D) -> void:
	if body is Golem and not body == golem and not _gazed_golem:
		golem.gaze_at(body)
		_gazed_golem = body

func _on_gaze_area_body_exited(body: Node3D) -> void:
	if body == _gazed_golem:
		golem.gaze_at(null)
		_gazed_golem = null
