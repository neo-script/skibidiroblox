extends CanvasLayer

@onready var time_label = $Control/TimeLabel
@onready var stage_label = $Control/StageLabel

func _ready():
	GameManager.time_updated.connect(update_timer)
	GameManager.stage_changed.connect(update_stage)

func update_timer(new_time):
	time_label.text = new_time

func update_stage(new_stage):
	stage_label.text = new_stage
