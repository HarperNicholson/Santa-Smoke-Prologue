extends Button

var itBegin : bool = false

func _on_pressed():
	if itBegin == false:
		canecount.canes += 25
		if canecount.canes >= 100:
			itBegin = true
			$secrettimer.start()
			get_tree().call_group("blackOverlay", "fade_in")


func _on_secrettimer_timeout():
	get_tree().change_scene_to_file("res://assets/background/hell.tscn")
