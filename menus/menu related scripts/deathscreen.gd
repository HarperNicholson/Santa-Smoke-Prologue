extends CanvasLayer

var hover = preload("res://sounds/clicking/eat2.wav")
var click = preload("res://sounds/clicking/eat3.wav")

var deathmusic = preload("res://sounds/music/death draft.mp3")

@onready var pauseLayerAudio = get_node("pauseLayerAudio")

#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
# as well as
#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
#can be used to hide the mouse with if using gamepad input

#   FIX  PAUSE  LOGIC,  USE  A  TOGGLE  SINGLE  BUTTON  THAT  CHANGES  TEXTURE
#   SO THAT  YOU CAN HEAR THE CLICK SOUND INSTEAD OF HOVER SOUND

func _ready():
	if canecount.golden_santa == true:
		$Sprite2D.texture = load("res://assets/santa/golden santa.png")
		
	achievements.unlock_achievement("YOUGOTTOOCOLD")
	
	
	get_tree().call_group("blackOverlay", "fade_out")
	$deathmusic.set_stream(deathmusic) 
	$deathmusic.play()
	


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

func _on_timer_timeout():
	get_tree().change_scene_to_file("res://menus/main.tscn")


func _on_restart_timer_timeout():
	get_tree().change_scene_to_file("res://snowy.tscn")\
