# golem
Project Golem

## Create your own humanoid

Open directory res://addons/golem/humanoid
Create a new inherited scene on humanoid.tscn
Rename scene name and save it
Create or load animation libraries in AnimationPlayer node
Create animation state node under AnimationStateMachine node
Add imported human scene contains skeleton under Model node
	Imported human scene should face to forward direction (-Z axis) in default
Instantiate humanoid_Look_at.tscn under skeleton node
