extends CharacterBody3D

@export var move_speed : float = 8.0
@export var acceleration : float = 20.0

@export var _gravity := -30.0
@export var jump_impulse : float = 12.0

@export var rot_speed := 12.0
# animation change idle/run
@export var anim_change : float = 1.0

@export_group("Camera")
@export_range(0.0, 1.0) var mouse_sensitivity := 0.25 #0.1?

#@export var tilt_upper_limit := PI / 3.0
#@export var tilt_lower_limit := -PI / 8.0
@onready var _camera_pivot: Node3D = %CamPivot
@onready var _camera_twist: Node3D = %CamTwist
@onready var _camera: Camera3D = %Camera3D

var _camera_input_direction: Vector2 = Vector2.ZERO

func _unhandled_input(event: InputEvent) -> void:
	var is_camera_motion : bool = (
		event is InputEventMouseMotion and 
		Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	)
	if is_camera_motion:
		#_camera_input_direction = event.screen_relative * mouse_sensitivity
		_camera_input_direction = event.relative * mouse_sensitivity

func _input(event: InputEvent) -> void:
	if event.is_action_pressed('mouse_click'):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed('ui_cancel'):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	

func _physics_process(delta: float) -> void:
	# twist pivot up/down
	_camera_twist.rotation.z -= _camera_input_direction.y * delta
	_camera_twist.rotation.z = clamp(_camera_twist.rotation.z, -PI / 4.0, PI / 120.0)
#player left/right

	self.rotation.y -= _camera_input_direction.x * delta
	
	_camera_input_direction = Vector2.ZERO
	
	var move_input := InputActions.get_move_vector()
	var forward := _camera.global_basis.z
	forward.y = 0.0
	forward = forward.normalized()
	
	var right := _camera.global_basis.x
	right.y = 0.0
	right = right.normalized()
	
	var move_direction := forward * move_input.y + right * move_input.x
	
	
	var y_velocity := velocity.y
	velocity.y = 0.0
	velocity = velocity.move_toward(move_direction * move_speed, acceleration * delta)
	 
	
	if not is_on_floor():
		velocity.y = y_velocity + _gravity * delta
		
	var is_jumping := InputActions.is_jump_pressed() and is_on_floor()
	if is_jumping:
		velocity.y = jump_impulse
		#add sound
		
	move_and_slide()
	
	
	#var ground_speed := velocity.lenght()
