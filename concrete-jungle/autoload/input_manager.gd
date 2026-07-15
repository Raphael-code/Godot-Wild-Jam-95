extends Node

const CONTROLS := {
	MOVE_FW    = "MOVE_FW",
	MOVE_BCK  = "MOVE_BCK",
	MOVE_LEFT  = "MOVE_LEFT",
	MOVE_RIGHT = "MOVE_RIGHT",
	JUMP   = "JUMP",
}

const CONTROLS_PROPAGATION := {
	CONTROLS.MOVE_FW:	[CONTROLS.MOVE_FW,		"ui_up"],
	CONTROLS.MOVE_BCK:	[CONTROLS.MOVE_BCK,		"ui_down"],
	CONTROLS.MOVE_LEFT:	[CONTROLS.MOVE_LEFT,	"ui_left"],
	CONTROLS.MOVE_RIGHT:[CONTROLS.MOVE_RIGHT,	"ui_right"],
}


#func _ready() -> void:
##	wait for template scripts - PlayerConfig / AppSettings
	#await get_tree().process_frame
	#sync_ui_navigation()
#
#func sync_ui_navigation() -> void:
	#print("Syncing UI navigation...")
	#for controls in CONTROLS_PROPAGATION:
		#var events : Array = []
		#if PlayerConfig and AppSettings:
			#events = PlayerConfig.get_config(AppSettings.INPUT_SECTION, controls, [])
		#print("controls...")
		
