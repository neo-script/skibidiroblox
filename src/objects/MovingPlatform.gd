extends AnimatableBody3D

@export var move_vector: Vector3 = Vector3(0, 5, 0)
@export var time_to_move: float = 3.0

func _ready():
	var tween = create_tween().set_loops().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position", position + move_vector, time_to_move)
	tween.tween_property(self, "position", position, time_to_move)
