extends Area3D

@export var player: CharacterBody3D

func _on_body_entered(body: Node3D) -> void:
	print("enter body")
	if body == player:
		print("Player died!")
		get_tree().reload_current_scene()
