extends CanvasLayer

var hover = preload("res://sounds/clicking/eat2.wav")
var click = preload("res://sounds/clicking/eat3.wav")


@onready var pauseLayerAudio = get_node("pauseLayerAudio")


func _ready():
	var sceneName = get_tree().current_scene.name
	if sceneName == "ChimneyLevel" or sceneName == "Intro":
		$pauseMenu/PauseTexture.texture = load("res://assets/chimney/assets/chimneyUI.png")
		#$pauseMenu/PauseTexture/bControls
		#$pauseMenu/PauseTexture/bRestart        give a theme at some point
		#$pauseMenu/PauseTexture/bQuit
	elif sceneName == "newHell":
		var orangeTheme = load("res://orange_theme.tres")
		$pauseMenu/PauseTexture.texture = load("res://assets/background/hell/hellUI.png")
		$pauseMenu/PauseTexture/PausedLabel.theme = orangeTheme
		$pauseMenu/PauseTexture/bControls.theme = orangeTheme
		$pauseMenu/PauseTexture/bRestart.theme = orangeTheme
		$pauseMenu/PauseTexture/bQuit.theme = orangeTheme
	else:
		$pauseMenu/PauseTexture.texture = load("res://menus/pause/pause_snow.png")

#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
# as well as
#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
#can be used to hide the mouse with if using gamepad input

#   FIX  PAUSE  LOGIC,  USE  A  TOGGLE  SINGLE  BUTTON  THAT  CHANGES  TEXTURE
#   SO THAT  YOU CAN HEAR THE CLICK SOUND INSTEAD OF HOVER SOUND

#PAUSE BUTTON
func _on_pause_button_mouse_entered():
	$pauseButton.modulate.a = 1
	if (globalmute.isMuted == false):
		pauseLayerAudio.set_stream(hover)
		pauseLayerAudio.play()
func _on_pause_button_mouse_exited():
	$pauseButton.modulate.a = 0.5
func _on_pause_button_pressed():
	if (globalmute.isMuted == false):
		pauseLayerAudio.set_stream(click)
		pauseLayerAudio.play()
	$pauseButton.hide()
	$playButton.show()
	$pauseMenu.show()
	# Pause the game by pausing the root of the scene tree
	get_tree().paused = true
	
	# Enable input processing for the menu
	$pauseMenu.set_process_input(true)
	$playButton.set_process_input(true)
	if $"../UILayer" != null:
		$"../UILayer".hide()

#UNPAUSE BUTTON
func _on_play_button_mouse_entered():
	$playButton.modulate.a = 1
	if (globalmute.isMuted == false):
		pauseLayerAudio.set_stream(hover)
		pauseLayerAudio.play()
func _on_play_button_mouse_exited():
	$playButton.modulate.a = 0.5
func _on_play_button_pressed():
	if (globalmute.isMuted == false):
		pauseLayerAudio.set_stream(click)
		pauseLayerAudio.play()
	$playButton.hide()
	$pauseButton.show()
	$pauseMenu.hide()
	# Pause the game by pausing the root of the scene tree
	get_tree().paused = false
	if $"../UILayer" != null:
		$"../UILayer".show()




func _on_b_controls_mouse_entered():
	if (globalmute.isMuted == false):
		pauseLayerAudio.set_stream(hover)
		pauseLayerAudio.play()

func _on_b_controls_pressed():
	if (globalmute.isMuted == false):
		pauseLayerAudio.set_stream(click)
		pauseLayerAudio.play()
	$pauseMenu/PauseTexture.hide()
	$pauseMenu/Controls.show()


func _on_b_restart_mouse_entered():
	if (globalmute.isMuted == false):
		pauseLayerAudio.set_stream(hover)
		pauseLayerAudio.play()
func _on_b_restart_pressed():
	if (globalmute.isMuted == false):
		pauseLayerAudio.set_stream(click)
		pauseLayerAudio.play()
	get_tree().call_group("blackOverlay", "fade_in")
	$RestartTimer.start()
	get_tree().paused = false


func _on_b_quit_mouse_entered():
	if (globalmute.isMuted == false):
		pauseLayerAudio.set_stream(hover)
		pauseLayerAudio.play()
func _on_b_quit_pressed():
	if (globalmute.isMuted == false):
		pauseLayerAudio.set_stream(click)
		pauseLayerAudio.play()
	get_tree().call_group("blackOverlay", "fade_in")
	$Timer.start()
	get_tree().paused = false


func _on_back_mouse_entered():
	if (globalmute.isMuted == false):
		pauseLayerAudio.set_stream(hover)
		pauseLayerAudio.play()
func _on_back_pressed():
	if (globalmute.isMuted == false):
		pauseLayerAudio.set_stream(click)
		pauseLayerAudio.play()
	$pauseMenu/PauseTexture.show()
	$pauseMenu/Controls.hide()


func _on_timer_timeout():
	get_tree().change_scene_to_file("res://menus/main.tscn")


func _on_restart_timer_timeout():
	canecount.resetSantaName()
	get_tree().reload_current_scene()
