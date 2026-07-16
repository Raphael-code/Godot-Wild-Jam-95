class_name InputActions
extends Node

const ACTIONS := {
	MOVE_FW =	"MOVE_FW",
	MOVE_BCK =	"MOVE_BCK",
	MOVE_LEFT =	"MOVE_LEFT",
	MOVE_RIGHT ="MOVE_RIGHT",
	JUMP = 		"JUMP",
}

static func get_move_vector() -> Vector2:
	return Input.get_vector(
		ACTIONS.MOVE_LEFT,
		ACTIONS.MOVE_RIGHT,
		ACTIONS.MOVE_FW,
		ACTIONS.MOVE_BCK
	)
	
#add others
static func is_jump_pressed() -> bool:
	return Input.is_action_pressed(ACTIONS.JUMP)
