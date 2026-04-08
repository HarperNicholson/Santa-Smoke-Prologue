extends Node2D

var doneCutscene : bool = false #for flagging when all the scripted and lore stuff is done

var dialogueCount : int = 0

func _ready():
	canecount.isIcewallMoving = false
	canecount.canes = 0

func _process(_delta):
	if doneCutscene == false:
		$SantaPlayer.disabled_input = true
		if Input.is_action_just_pressed("mouse_click"):
			print("Mouse clicked")
			$AudioStreamPlayer.play()
			dialogueCount = dialogueCount + 1
			dialogueAdvance()
	else:
		if canecount.golden_santa == false:
			$SantaPlayer.disabled_input = false
		

var callPlay = false

func dialogueAdvance():
	if dialogueCount == 1:
		$CanvasLayer/clickto.queue_free()
		$CanvasLayer/clickto2.show()
	elif dialogueCount == 2:
		$CanvasLayer/clickto2.text = "HE    IS    IN    THE    MOOD    TO    EAT    CANDYCANES."
	elif dialogueCount == 3:
		$CanvasLayer/clickto2.text = "HE    SHOULD    LOOK    AT    THE    CONTROLS    IF    HE    HAS    FORGOTTEN    HOW    TO    DO    THAT."
		$CanvasLayer/clickto3.show()
	elif dialogueCount == 4:
		$CanvasLayer/clickto2.text = "THERE    ARE    MANY    DIFFERENT    PATHS    SANTA    COULD    TAKE    TODAY..."
		$CanvasLayer/clickto3.queue_free()
	elif dialogueCount == 5:
		$CanvasLayer/clickto2.hide()
		$Node2D.show()
		$CanvasLayer/clickto4.show()
	elif dialogueCount == 6:
		$CanvasLayer/clickto2.show()
		$CanvasLayer/clickto2.text = "IT    VERY    COLD!    HE    SHOULD    WATCH    OUT    FOR    ICE."
		$CanvasLayer/clickto4.queue_free()
	elif dialogueCount == 7:
		doneCutscene = true
		$CanvasLayer/clickto2.queue_free()
		var icedist = get_tree().create_tween()
		icedist.tween_property($Icewall, "position:y", 720, 2)
		if callPlay == false:
			$draggingsound.play()
			$icewallmovementtimer.start()
			callPlay = true


func _on_icewallmovementtimer_timeout():
	$draggingsound.stop()


func _on_haha_timer_timeout():
	if canecount.haha == true:
		print("ATTEMPTING UNLOCK IF CONDITIONS MET")
		achievements.unlock_achievement("HAHA")
