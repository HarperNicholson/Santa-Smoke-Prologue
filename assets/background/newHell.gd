extends Node2D

var dialogueDone : bool = false
var dialogueCount : int = 0

var crunchsound = preload("res://sounds/candy/eat1.wav")

var cageMovementInterval : int = 30

var canTakeInput : bool = true

var maxDepth = 900
var steps : int = 26

var startPoint : float
var endPoint : float

var returnPoint = 500

var returnTime : float
var tweenTime : float

var hasStartedChainSounds : bool = false
var x = false
var y = false
var hasCalledA = false
func _ready():
	startPoint = $ForegroundCageParent.position.y
	endPoint = maxDepth
	
	tweenTime = $InputTimer.wait_time
	returnTime = $ReturnTimer.wait_time
	#$SantaPlayer.disabled_input = true
	call_deferred("remove_effect")
	canecount.allowUnstuck = false

func remove_effect():
	var bus_index = AudioServer.get_bus_index("Master")
	var effect_index = 0 # Adjust this index based on the effect you want to remove
	AudioServer.remove_bus_effect(bus_index, effect_index)


func _process(_delta):
	if dialogueDone == false:
		if canTakeInput == true:
			if Input.is_action_just_pressed("mouse_click"):
				if not hasStartedChainSounds:
					$ForegroundCageParent/ChainAudioStreamPlayer2D.play()
					hasStartedChainSounds = true
				print("Mouse clicked")
				if globalmute.isMuted == false:
					$devilaudioplayer.playRandomDevilSound()
				dialogueCount = dialogueCount + 1
				dialogueAdvance()
				if not x:
					moveCage()
				canTakeInput = false
				$InputTimer.start()
	
	if dialogueCount == 26 and not x:
		if $ForegroundCageParent.position.y == maxDepth:
			#ascend back up to a return point, play
			var returnTween = get_tree().create_tween()
			returnTween.tween_property($ForegroundCageParent, "position:y", returnPoint, returnTime)
			$ForegroundCageParent/ChainAudioStreamPlayer2D.stream_paused = false
			$ForegroundCageParent/ChainAudioStreamPlayer2D.play()
			$ReturnTimer.start()
			x = true
	
	if dialogueCount == 26 and not y:
		canTakeInput = false
	
	if canecount.elfIsAblazeIRepeatElfIsAblaze == true and !achievements.is_achieved("EVIL"):
		achievements.unlock_achievement("EVIL")
	
	if canecount.santaSmoke == true and not hasCalledA:
		hasCalledA = true
		dialogueDone = true
		$devilaudioplayer.playHehehe()
		$SPEECH1_LOWERCASE.text = ("")
		$SPEECH1.text = ("")
		$SPEECH2.text = ("")
		$SantaPlayer.disabled_input = true
		$SantaPlayer.velocity.x = 0
		
		var temptimer = get_tree().create_timer(2)
		
		await(temptimer.timeout)
		var camera = Camera2D.new()
		camera.position = Vector2(0, -20)
		camera.zoom = Vector2(4.5, 4.5)
		canecount.done = true
		$SantaPlayer.add_child(camera)
		$SantaPlayer/AnimatedSprite2D.play("santa_smoke")
		
		if canecount.secretCharacter == false:
			$SmokeAudio.play()
		var h = get_tree().create_timer(0.9)
		await(h.timeout)
		if canecount.secretCharacter == false:
			$SantaPlayer/CPUParticles2D.emitting = true
		
		var zoomtimer = get_tree().create_timer(1.5)
		
		await(zoomtimer.timeout)
		var zoomTween = get_tree().create_tween()
		zoomTween.tween_property(camera, "zoom", Vector2(45, 45), 2)
		var a = get_tree().create_timer(0.5)
		await(a.timeout)
		$UILayer/CanvasLayer.fade_on()
		
		var b = get_tree().create_timer(1)
		await(b.timeout)
		
		$UILayer/CanvasLayer2.fade_off()
		$UILayer/CanvasLayer/Texts.show()
		var C = get_tree().create_timer(4)
		await(C.timeout)
		get_tree().call_group("blackOverlay", "fade_in")
		var quit = get_tree().create_timer(1.1)
		await(quit.timeout)
		get_tree().change_scene_to_file("res://menus/main.tscn")

func chimneyAchieveyFinal():
	achievements.unlock_achievement("SAYNOTOSMOKING")

func moveCage():
	if $ForegroundCageParent.position.y < maxDepth:
		
		#normal descent logic
		#move from start point to end point, at increments matching dialogue
		var step = dialogueCount
		
		var progress = float(step) / steps # Ensure floating-point division
		
		var targetPoint = lerp(startPoint, endPoint, progress)
		
		print("Progress: ", progress) # Debugging
		print("Target Point: ", targetPoint)
		
		
		
		#move increment $ForegroundCageParent
		#simple linear tween,
		# from current position to target position, at same time as input delay
		
		var tween = get_tree().create_tween()
		tween.tween_property($ForegroundCageParent, "position:y", targetPoint, tweenTime)
		$ForegroundCageParent/ChainAudioStreamPlayer2D.stream_paused = false
	

func dialogueAdvance():
	if dialogueCount == 1:
		$SPEECH1.text = ("HELLO.")
		$SPEECH2.text = ("")
		$clickto.hide()
	elif dialogueCount == 2:
		$SPEECH2.text = ("I    AM    THE    DEVIL.")
		$clickto.hide()
	elif dialogueCount == 3:
		$SPEECH1.text = ("I    AM    VERY   EVIL")
		$clickto.hide()
	elif dialogueCount == 4:
		$SPEECH1.text = ("LOTS    OF    CANES    YOU    HAVE    COLLECTED    THERE!")
		$SPEECH2.text = ("")
	elif dialogueCount == 5:
		$SPEECH1.text = ("LOTS    OF    CANES    YOU    HAVE    COLLECTED    THERE!")
		$SPEECH2.text = ("AS    SUCH,    I    NEED    THEM    FOR    CONNIVING")
	elif dialogueCount == 6:
		$SPEECH1.text = ("GIVE    ME    YOUR    HINDMOST")
		$SPEECH2.text = ("")
	elif dialogueCount == 7:
		$SPEECH1.text = ("GIVE    ME    YOUR    HINDMOST")
		$SPEECH2.text = ("[THE     DEVIL     TAKES     THE     HINDMOST]")
		canecount.canes = 0
		canecount.lastCaneType = "nullcane"
		if globalmute.isMuted == false:
			$AudioStreamPlayer.set_stream(crunchsound)
			$AudioStreamPlayer.play()
	elif dialogueCount == 8:
		$SPEECH1_LOWERCASE.text = ("scrumptious")
		$SPEECH1.text = ("")
		$SPEECH2.text = ("")
	elif dialogueCount == 9:
		$SPEECH2.text = ("YOUR    BROTHER    SAYS    HELLO")
	elif dialogueCount == 10:
		$SPEECH1_LOWERCASE.text = ("")
		$SPEECH1.text = ("YES,   I'VE   BEEN   KEEPING   MY   WATCHFUL   EYES   ON   HIM")
		$SPEECH2.text = ("YOUR    BROTHER    SAYS    HELLO")
	elif dialogueCount == 11:
		$SPEECH1_LOWERCASE.text = ("he    never    really    stood    a    chance.")
		$SPEECH1.text = ("")
		$SPEECH2.text = ("")
	elif dialogueCount == 12:
		$SPEECH1_LOWERCASE.text = ("")
		$SPEECH1.text = ("WHERE    IS    HE?   OUT   THERE,   SOMEWHERE")
		$SPEECH2.text = ("")
	elif dialogueCount == 13:
		$SPEECH1.text = ("WHERE    IS    HE?   OUT   THERE,   SOMEWHERE")
		$SPEECH2.text = ("REGARDLESS    OF   HIM,   YOU   SHOULD   TRY   SMOKING!!")
		var smokeInstance = load("res://assets/background/hell/cigger.tscn").instantiate()
		smokeInstance.position.y = 460
		smokeInstance.position.x = 520
		smokeInstance.z_index = -1
		self.add_child(smokeInstance)
	elif dialogueCount == 14:
		$SPEECH1.text = ("IT'S   JUST    [TERRIBLE]    FOR    YOU,   AHAH!")
		$SPEECH2.text = ("REGARDLESS    OF   HIM,   YOU   SHOULD   TRY   SMOKING!!")
	elif dialogueCount == 15:
		$SPEECH1.text = ("AGHAK   ACK   AGH  KAUGH  AG   AGHK")
		$SPEECH2.text = ("")
	elif dialogueCount == 16:
		$SPEECH1.text = ("AGHAK   ACK   AGH  KAUGH  AG   AGHK")
		$SPEECH2.text = ("ACOGHK   OCH   COUGH")
	elif dialogueCount == 17:
		$SPEECH1.text = ("WHAT   DO   YOU    SAY?")
		$SPEECH2.text = ("")
	elif dialogueCount == 18:
		$SPEECH1_LOWERCASE.text = ("you   can   always   turn   around.")
		$SPEECH1.text = ("")
	elif dialogueCount == 19:
		$SPEECH1_LOWERCASE.text = ("back   up   the   chimney.")
		var chimneyInstance = load("res://assets/chimney/chimney.tscn").instantiate()
		chimneyInstance.position.y = 408
		chimneyInstance.position.x = -50
		chimneyInstance.targetScene = "res://menus/main.tscn"
		chimneyInstance.modulate.a = 0
		chimneyInstance.z_index = -1
		self.add_child(chimneyInstance)
		var chimneyFadeTween = get_tree().create_tween()
		chimneyFadeTween.tween_property(chimneyInstance, "modulate:a", 1, 2)
		
	elif dialogueCount == 20:
		$SPEECH1_LOWERCASE.text = ("")
		$SPEECH1.text = ("....")
		#speech1. font normal
	elif dialogueCount == 21:
		$SPEECH1.text = ("OK")
	elif dialogueCount == 22:
		$SPEECH1.text = ("??????")
	elif dialogueCount == 23:
		$SPEECH1.text = ("")
		$SPEECH1_LOWERCASE.text = ("i didn't really expect this out of you.")
	elif dialogueCount == 24:
		$SPEECH1_LOWERCASE.text = ("that's just evil, you could have just taken the cigarette and left")
	elif dialogueCount == 25:
		$SPEECH1_LOWERCASE.text = ("I'm the devil, and I'm saying what you did is evil")
	elif dialogueCount == 26:
		$SPEECH1_LOWERCASE.text = ("Let's see what the damage is...")
	elif dialogueCount == 27:
		$SPEECH1_LOWERCASE.text = ("I have nothing else to say. I was gonna do it anyway, but I was gonna wait until after you left")
		dialogueDone = true

func _on_timer_timeout():
	if $clickto.visible == false && dialogueCount <= 1:
		$clickto.show()


func _on_lava_2_body_exited(body):
	if body.is_in_group("burnable"):
		if body.isOnFire:
			if body.has_node("AudioStreamPlayer2D"):
				var bodyStreamPlayer = body.get_node("AudioStreamPlayer2D")
				bodyStreamPlayer.stop()


func _on_input_timer_timeout():
	$ForegroundCageParent/ChainAudioStreamPlayer2D.stream_paused = true
	canTakeInput = true


func _on_return_timer_timeout():
	$ForegroundCageParent/ChainAudioStreamPlayer2D.stop()
	y = true
	canTakeInput = true
	$devilaudioplayer.playRandomDevilSound()
	$SPEECH1_LOWERCASE.text = ("Congrats, he is now a pile of ash or something. Probably liquefied. You dunked him into flowing magma.")
