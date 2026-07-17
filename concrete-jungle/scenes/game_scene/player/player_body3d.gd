extends CharacterBody3D

@export var move_speed : float = 8.0
@export var acceleration : float = 20.0
var dash_speed : float = 16.0
@export var dash_duration : float = 0.2
@export var dash_cooldown : float = 0.6
var dash_timer : float = 0.0
var dash_cooldown_timer : float = 0.0
var is_dash_active : bool = false
var dash_dir : Vector3 = Vector3.ZERO
@export var _gravity := -30.0
@export var jump_impulse : float = 12.0
var wall_jump_impulse : float = 12.0
var jumped = 0
var last_wall = null
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
var _was_on_floor: bool = false

@onready var _landing_particles: GPUParticles3D = %LandingParticles
# maybe in animation? footstepsfrom animation also - change player child nodes later
# @onready var _run_particles: GPUParticles3D = %RunParticles
#_run_particles.emitting = is_on_floor() and velocity.length() > 1

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
	
func get_wall_side():
	var hit = get_wall_normal()
	last_wall = hit
	velocity = hit * wall_jump_impulse
	velocity.y = wall_jump_impulse


var dash_pressed_last_frame : bool = false

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
		
	if last_wall == null or (get_wall_normal() != last_wall):
		jumped = 0
		

	var is_jumping := InputActions.is_jump_pressed() and is_on_floor()
	var is_on_ground := is_on_floor()
	var is_dashing := InputActions.is_dash_pressed()
	var is_wall_jumping := InputActions.is_jump_pressed() and !is_on_floor() and is_on_wall() and jumped == 0
	
	
	if is_jumping:
		# %PlayerJump.play()
		velocity.y = jump_impulse

	if is_on_ground:
		jumped = 0
		last_wall = null
	if is_on_wall() and !is_on_floor():
		velocity.y = -10
		last_wall = get_wall_normal()
	if is_wall_jumping:
		# %PlayerJump.play()
		last_wall = get_wall_normal()
		jumped = 1
		get_wall_side()
		#add sound



	if dash_cooldown_timer > 0.0:
		dash_cooldown_timer -= delta
	if is_dashing and dash_cooldown_timer <= 0.0 and not is_dash_active:
		is_dash_active = true
		dash_timer = dash_duration
		dash_cooldown_timer = dash_cooldown
		dash_dir = self.global_transform.basis.x
	if is_dash_active:
		velocity.x = dash_dir.x * dash_speed
		velocity.z = dash_dir.z * dash_speed
		velocity.y = 0.0
		dash_timer -= delta
		if dash_timer <= 0.0:
			is_dash_active = false

	move_and_slide()
	if !_was_on_floor and is_on_floor():
		print("landed")
		# %PlayerLand.play()
		# _landing_particles.restart()
	
	# land particles
	_was_on_floor = is_on_floor()
	
	#var ground_speed := velocity.lenght()
	
	#var ground_speed := velocity.lenght()
