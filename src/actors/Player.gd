extends CharacterBody3D

@export_group("Movement Config")
@export var speed: float = 12.0
@export var jump_force: float = 18.0
@export var gravity: float = 40.0
@export var acceleration: float = 0.2  # Ground friction
@export var air_control: float = 0.05  # Air friction

@onready var camera_pivot = $CameraPivot
@onready var coyote_timer = $CoyoteTimer

var was_on_floor: bool = false

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	# Set initial spawn point
	GameManager.current_checkpoint_coords = global_position

func _input(event):
	# Camera Rotation
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * 0.005)
		camera_pivot.rotate_x(-event.relative.y * 0.005)
		# Clamp looking up/down
		camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, deg_to_rad(-60), deg_to_rad(30))

func _physics_process(delta):
	# 1. Apply Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		was_on_floor = true
		
	# Coyote Time Logic: If we just walked off a ledge, start timer
	if was_on_floor and not is_on_floor() and coyote_timer.is_stopped():
		coyote_timer.start()

	# 2. Handle Jump
	var can_jump = is_on_floor() or not coyote_timer.is_stopped()
	if Input.is_action_just_pressed("ui_accept") and can_jump:
		velocity.y = jump_force
		coyote_timer.stop() # Prevent double jumps

	# 3. Movement
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		# Snappy movement
		velocity.x = lerp(velocity.x, direction.x * speed, acceleration if is_on_floor() else air_control)
		velocity.z = lerp(velocity.z, direction.z * speed, acceleration if is_on_floor() else air_control)
	else:
		# Quick stop
		velocity.x = lerp(velocity.x, 0.0, acceleration)
		velocity.z = lerp(velocity.z, 0.0, acceleration)

	move_and_slide()
	was_on_floor = is_on_floor()

# Helper to die
func die():
	GameManager.respawn_player(self)
