extends CharacterBody3D
@export_group("Camera")
@export_range(0.0, 1.0) var mouse_sensitivity := 0.25
#0.01
#@export var tilt_upper_limit := PI / 3.0
#@export var tilt_lower_limit := -PI / 8.0
@onready var _camera_pivot: Node3D = %CamPivot

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
	
	
#func _physics_process(delta: float) -> void:
	#_camera_pivot.rotation.x -= _camera_input_direction.y * delta
	#_camera_pivot.rotation.x = clamp(_camera_pivot.rotation.x, -PI / 3.0, -PI/8.0 )
	#_camera_pivot.rotation.y -= _camera_input_direction.x * delta
	#_camera_input_direction = Vector2.ZERO

func _physics_process(delta: float) -> void:
	# pivot up/down
	_camera_pivot.rotation.x -= _camera_input_direction.y * delta
	_camera_pivot.rotation.x = clamp(_camera_pivot.rotation.x, -PI / 3.0, PI / 3.0)
#player left/right
	self.rotation.y -= _camera_input_direction.x * delta
	
	_camera_input_direction = Vector2.ZERO
