extends Node

# Signals logic uses to talk to UI
signal score_updated(new_score)
signal time_updated(time_string)
signal stage_changed(stage_name)

var current_checkpoint_coords: Vector3 = Vector3.ZERO
var current_stage: int = 1
var start_time: int = 0
var is_running: bool = false

func _ready():
	# Start timer when game loads
	start_time = Time.get_ticks_msec()
	is_running = true

func _process(_delta):
	if is_running:
		var elapsed = Time.get_ticks_msec() - start_time
		var minutes = (elapsed / 1000) / 60
		var seconds = (elapsed / 1000) % 60
		var milliseconds = (elapsed % 1000) / 10
		var time_str = "%02d:%02d.%02d" % [minutes, seconds, milliseconds]
		emit_signal("time_updated", time_str)

func update_checkpoint(pos: Vector3, stage_num: int):
	# Only update if we reached a *new* checkpoint
	if stage_num > current_stage:
		current_checkpoint_coords = pos
		current_stage = stage_num
		emit_signal("stage_changed", "Stage %d" % current_stage)
		# Play a sound here if you want!

func respawn_player(player_node):
	player_node.global_position = current_checkpoint_coords
	player_node.velocity = Vector3.ZERO
