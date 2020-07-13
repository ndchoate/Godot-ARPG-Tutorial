extends Area2D

var player = null


func can_see_player():
	return player != null


func _on_PlayerDetectionZone_body_entered(body):
	# Player is set to the Collision body when player enters the collision zone
	player = body


func _on_PlayerDetectionZone_body_exited(body):
	# Player is set to null whenever the player is outside of the detection zone
	player = null
