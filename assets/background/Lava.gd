extends Area2D


var hasRelevantBody = false
var relevantBody = null

func _on_body_entered(body):
	if body.name == "SantaPlayer":
		$AudioStreamPlayer.play()
		ProjectSettings.set_setting("physics/2d/default_gravity", 2)
		body.isOnFire = true
		hasRelevantBody = true
		relevantBody = body
		if !achievements.is_achieved("WHY"):
			achievements.unlock_achievement("WHY")
	elif body.is_in_group("burnable"):
		body.isOnFire = true
		hasRelevantBody = true
		relevantBody = body
	


func _physics_process(_delta):
	if relevantBody == null:
		hasRelevantBody = false
	
	if hasRelevantBody:
		relevantBody.velocity.x = relevantBody.velocity.x / 4
		if relevantBody.is_in_group("burnable"):
			relevantBody.jumps = 5
			relevantBody.velocity.y = relevantBody.velocity.y / 4
		elif relevantBody.name == "SantaPlayer":
			relevantBody.velocity.y = clamp(0, 30, relevantBody.velocity.y)
			relevantBody.jumps_taken = 5




func _on_body_exited(_body):
	relevantBody = null
