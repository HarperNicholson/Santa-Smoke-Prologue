extends CanvasLayer

var hover = preload("res://sounds/clicking/eat2.wav")
var click = preload("res://sounds/clicking/eat3.wav")

func _ready():
	if canecount.golden_santa == true:
		$Sprite2D.texture = load("res://assets/santa/golden santa.png")
	
	achievements.unlock_achievement("LOSTINSPACE")
	
	get_tree().call_group("blackOverlay", "fade_out")
	spaceRotate()


func _on_b_restart_mouse_entered():
	if (globalmute.isMuted == false):
		$pauseLayerAudio.set_stream(hover)
		$pauseLayerAudio.play()
func _on_b_restart_pressed():
	if (globalmute.isMuted == false):
		$pauseLayerAudio.set_stream(click)
		$pauseLayerAudio.play()
	get_tree().call_group("blackOverlay", "fade_in")
	$RestartTimer.start()
	get_tree().paused = false


func _on_b_quit_mouse_entered():
	if (globalmute.isMuted == false):
		$pauseLayerAudio.set_stream(hover)
		$pauseLayerAudio.play()
func _on_b_quit_pressed():
	if (globalmute.isMuted == false):
		$pauseLayerAudio.set_stream(click)
		$pauseLayerAudio.play()
	get_tree().call_group("blackOverlay", "fade_in")
	$Timer.start()
	get_tree().paused = false

func spaceRotate():
	#rotate santa sprite 360 in 1 second
	var rotatetween = get_tree().create_tween()
	rotatetween.tween_property($Sprite2D, "rotation",
						 $Sprite2D.rotation+1, # End alpha
						 1)


func _on_rotatetimer_timeout():
	spaceRotate()

func _on_timer_timeout():
	get_tree().change_scene_to_file("res://menus/main.tscn")


func _on_restart_timer_timeout():
	get_tree().change_scene_to_file("res://snowy.tscn")
