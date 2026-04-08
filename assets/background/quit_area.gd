extends Area2D

func _on_body_entered(body):
	if body.name == ("SantaPlayer"):
		get_tree().call_group("blackOverlay", "fade_in")
		$quitAreatimer.start()
		get_tree().paused = false
	elif body.is_in_group("cullable"):
		body.queue_free()

func _on_quit_areatimer_timeout():
	#get_tree().change_scene_to_file("res://menus/main.tscn")
	get_tree().reload_current_scene()
