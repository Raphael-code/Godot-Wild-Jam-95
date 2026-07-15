extends Node

const CONTROLS := {
	MOVE_FW    = "MOVE_FW",
	MOVE_BCK  = "MOVE_BCK",
	MOVE_LEFT  = "MOVE_LEFT",
	MOVE_RIGHT = "MOVE_RIGHT",
	JUMP   = "JUMP",
}

const CONTROLS_PROPAGATION := {
	CONTROLS.MOVE_FW:    [CONTROLS.MOVE_FW,    "ui_up"],
	CONTROLS.MOVE_BCK:  [CONTROLS.MOVE_BCK,  "ui_down"],
	CONTROLS.MOVE_LEFT:  [CONTROLS.MOVE_LEFT,  "ui_left"],
	CONTROLS.MOVE_RIGHT: [CONTROLS.MOVE_RIGHT, "ui_right"],
}


func _ready() -> void:
	sync_ui_navigation()

func sync_ui_navigation() -> void:
	for controls in CONTROLS_PROPAGATION:
		var events = PlayerConfig.get_config(AppSettings.INPUT_SECTION, controls, [])
		for ui_action in CONTROLS_PROPAGATION[controls]:
			InputMap.action_erase_events(ui_action)
			for event in events:
				InputMap.action_add_event(ui_action, event.duplicate())


func get_move_vector() -> Vector2:
	return Input.get_vector(CONTROLS.MOVE_LEFT, CONTROLS.MOVE_RIGHT, CONTROLS.MOVE_UP, CONTROLS.MOVE_DOWN)

func is_action_pressed(action: String) -> bool:
	return Input.is_action_pressed(action)
