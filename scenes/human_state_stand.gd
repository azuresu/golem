extends AnimationState

var human: Human:
	get: return owner

func _enter() -> void:
	human.velocity = Vector3(0, human.velocity.y, 0)
