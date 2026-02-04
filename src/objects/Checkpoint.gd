extends Area3D

@export var stage_number: int = 1
@export var active_color: Color = Color.GREEN
@export var inactive_color: Color = Color.WHITE

@onready var mesh = $MeshInstance3D

func _ready():
	body_entered.connect(_on_body_entered)
	var mat = StandardMaterial3D.new()
	mat.albedo_color = inactive_color
	mesh.material_override = mat

func _on_body_entered(body):
	if body.name == "Player":
		GameManager.update_checkpoint(global_position + Vector3(0, 1, 0), stage_number)
		# Visual feedback
		mesh.material_override.albedo_color = active_color
