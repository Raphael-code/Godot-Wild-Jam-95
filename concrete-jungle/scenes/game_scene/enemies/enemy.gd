extends CharacterBody3D

const SPEED = 5
const KILL_DISTANCE = 1.4

@export var player: CharacterBody3D

func _physics_process(delta):

	if player == null:
		return

	# Direction to player
	var direction = (player.global_position - global_position).normalized()

	var target_velocity = direction * SPEED

	velocity.x = move_toward(velocity.x, target_velocity.x, 15 * delta)
	velocity.z = move_toward(velocity.z, target_velocity.z, 15 * delta)

	# Kill player if close enough
	if global_position.distance_to(player.global_position) < KILL_DISTANCE:
		kill_player()
	
	move_and_slide()

func kill_player():
	print("Player died!")

	# Option 1: Reload the level
	get_tree().reload_current_scene()

	# Option 2: Call a function on the player
	# player.die()
