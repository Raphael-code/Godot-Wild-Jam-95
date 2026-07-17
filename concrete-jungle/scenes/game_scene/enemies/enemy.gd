extends CharacterBody3D

const SPEED = 5.0
@export var player: CharacterBody3D

func _physics_process(delta):
	if player == null:
		return

	var direction = (player.global_position - global_position).normalized()
	var target_velocity = direction * SPEED

	velocity.x = move_toward(velocity.x, target_velocity.x, 15 * delta)
	velocity.z = move_toward(velocity.z, target_velocity.z, 15 * delta)

	move_and_slide()


func _on_death_zone_body_entered(body: Node3D) -> void:
	print("enter body")
	if body == player:
		print("Player died!")
		get_tree().reload_current_scene()
