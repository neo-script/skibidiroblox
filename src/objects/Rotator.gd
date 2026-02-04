extends AnimatableBody3D

@export var rotation_speed: Vector3 = Vector3(0, 1, 0) # X, Y, Z speed

func _physics_process(delta):
	# Rotate the object constantly
	rotation += rotation_speed * delta
