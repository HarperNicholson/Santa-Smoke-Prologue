extends Node

var dialogueDone : bool = false
var dialogueCount : int = 0

var crunchsound = preload("res://sounds/candy/eat1.wav")

func _process(_delta):
	if dialogueDone == false:
		if Input.is_action_just_pressed("mouse_click"):
			print("Mouse clicked")
			if globalmute.isMuted == false:
				$devilaudioplayer.playRandomDevilSound()
			dialogueCount = dialogueCount + 1
			dialogueAdvance()
	if dialogueCount >= 17:
		if Input.is_key_pressed(KEY_Y):
			print("Y key pressed")
			$CanvasLayer.show()
			$CanvasLayer/VideoStreamPlayer.play()
		elif Input.is_key_pressed(KEY_N):
			print("N key pressed")
			get_tree().change_scene_to_file("res://menus/main.tscn")

func dialogueAdvance():
	if dialogueCount == 1:
		$SPEECH1.text = ("HELLO.")
		$SPEECH2.text = ("")
	elif dialogueCount == 2:
		$clickto.hide()
		$SPEECH2.text = ("I    AM    THE    DEVIL.")
	elif dialogueCount == 3:
		$SPEECH1.text = ("I    AM    VERY   EVIL")
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
		$SPEECH2.text = ("      Y/N")
	elif dialogueCount == 18:
		$SPEECH1_LOWERCASE.text = ("you   can   always   turn   around.")
		$SPEECH1.text = ("")
		$SPEECH2.text = ("      Y/N")
	elif dialogueCount == 19:
		$SPEECH1_LOWERCASE.text = ("back   up   the   chimney.")
		$SPEECH2.text = ("      Y/N")
	elif dialogueCount == 20:
		$SPEECH1_LOWERCASE.text = ("")
		$SPEECH1.text = ("....")
		#speech1. font normal
		$SPEECH2.text = ("      Y/N")
		dialogueDone = true


func _on_timer_timeout():
	if $clickto.visible == false && dialogueCount <= 1:
		$clickto.show()


func _on_unlock_timer_timeout():
	print("ATTEMPTING UNLOCK IF CONDITIONS MET")
	achievements.unlock_achievement("OLDHELL")
