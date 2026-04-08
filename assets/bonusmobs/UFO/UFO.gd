extends Node2D

var tracking : bool = false
var beaming : bool = false
var leaving : bool = false
var returning : bool = false
var leavingForGood : bool = false

var leaveTime : float = 0
var trackTime : float = 0
var beamTime : float = 0
var isAbductPosTaken
var abductionPointX : float
var abductionPointY : float
var insideShipPointY #NULL AS ALL HELL      THAT IS NOT A GOOD THIING

var target = null  # Variable to hold the target object
var startPosX = null

var timer = 0
var NEWtimer = 0

var isBeamEnabled = false


func _ready():
	find_nearest_target()
	
	print("X: " + str(position.x))
	print("Y: " + str(position.y))

func find_nearest_target():
	var nearest_distance = INF  # Start with infinity to ensure any object is closer
	var nearest_object = null
	startPosX = position.x
	insideShipPointY = $InsideShipPoint.position.y

	for object in get_tree().get_nodes_in_group("abductable"):
		# Check if the object is already being abducted
		if object.isBeingAbducted:
			continue  # Skip this object and check the next one

		var distance = position.distance_to(object.position)
		if distance < nearest_distance:
			nearest_distance = distance
			nearest_object = object

	if nearest_object != null:
		target = nearest_object
		tracking = true
		# Set the isBeingAbducted property to true to mark this target as being abducted
		target.isBeingAbducted = true
		print("tracking:  " + str(nearest_object))


var abductionSceneTimer = 0

var isTiming = true
var fuckyourself = false
var returndelta = 0

var callReturnSantaRepeated = false

var hasCall1 : bool = false
var hasCall2 : bool = false
var hasCall3 : bool = false
var hasCall4 : bool = false

func _physics_process(delta):
	if target == null:
		find_nearest_target()
	
	if returning == true:
		returnSanta(delta)
		if finalBeaming != true:
			target.position.x = position.x
			target.position.y = abductionPointY + insideShipPointY
			target.velocity.y = 0
			target.velocity.x = 0
		elif finalBeaming == true:
			returning = false
	if finalBeaming == true:
		var newDownbeamY = lerp(abductionPointY + insideShipPointY, abductionPointY, finalBeamTimer)
		target.position.y = newDownbeamY
		finalBeamTimer += delta / 3
		
		if finalBeamTimer >= 1.0:
			target.set_collision_layer_value(1, true)
			target.set_collision_mask_value(1, true)
			toggleBeamEffects()
			target.disabled_input = false
			canecount.isIcewallMoving = true
			leavingForGood = true
			finalBeaming = false
	if leavingForGood == true:
		leaveForGood(delta)
	if tracking:
		trackTime += delta / 9
		
		var factor = sin(trackTime * PI * 0.5)
		
		position.x = lerp(position.x, target.position.x, factor)
		position.y = target.position.y
		if abs(position.x - target.position.x) <= 2:
			beaming = true
			tracking = false
		
	if beaming:
		if not isAbductPosTaken:
			target.set_collision_layer_value(1, false)
			target.set_collision_mask_value(1, false)
			target.disabled_input = true
			target.velocity.x = 0
			target.velocity.y = 0
			if target.name == "SantaPlayer":
				canecount.isIcewallMoving = false
			abductionPointX = target.position.x
			abductionPointY = target.position.y
			$BeamSprite.speed_scale = -1
			$BeamSprite.play("beaming")
			toggleBeamEffects()
			isAbductPosTaken = true
		
		position.x = target.position.x
		var newUpbeamY = lerp(abductionPointY, abductionPointY + insideShipPointY, beamTime)
		target.position.y = newUpbeamY
		
		beamTime += delta / 3
		if beamTime >= 1.0:
			toggleBeamEffects()
			leaving = true
			beaming = false
	
	if leaving:
		leaveTime += delta / 8
		var factor = sin(leaveTime * PI * 0.5)
		
		position.x = lerp(position.x, -startPosX, factor)
		target.position.x = position.x
		target.position.y =  position.y + insideShipPointY
		if target.name == "SantaPlayer":
			if position.x == -startPosX:
				if hasCall1 == false:
					$"../../SantaPlayer/Camera2D/NewBlackOverlay".fade_on()
					hasCall1 = true
				
				if isTiming == true:
					timer += delta
				if timer >= 0.9:
					isTiming = false
					if hasCall2 == false:
						var interstellarmusic = load("res://sounds/music/interstellarfix.mp3")
						$"../../music".set_stream(interstellarmusic)
						$"../../music".set_volume_db(7)
						$"../../music".play()
						$ShipSound.stop()
						$"../../SantaPlayer/Camera2D/AbductionSceneLayer".show()
						$"../../SantaPlayer/Camera2D/NewBlackOverlay".fade_off()
						if not globalmute.isMuted == true:
							AudioServer.set_bus_mute(2, true)
						$"../../SantaPlayer/Camera2D/AbductionSceneLayer/AnimatedSprite2D".play("abduction")
						hasCall2 = true
					abductionSceneTimer += delta / 21.5
					if abductionSceneTimer >= 1: # calculate duration of abduction scene by frames, then after that time has elapsed (RETARDED WORKAROUND BECAUSE ON SIGNALS ARE USELESS):
						if hasCall3 == false:
							$"../../SantaPlayer/Camera2D/NewBlackOverlay".fade_on()
							hasCall3 = true
						if not fuckyourself:
							NEWtimer += delta
						if NEWtimer >= 0.9:
							if hasCall4 == false:
								$"../../SantaPlayer/Camera2D/AbductionSceneLayer/AnimatedSprite2D".stop()
								$"../../SantaPlayer/Camera2D/AbductionSceneLayer".hide()
								$"../../SantaPlayer/Camera2D/NewBlackOverlay".fade_off()
								if not globalmute.isMuted == true:
									AudioServer.set_bus_mute(2, false)
								fuckyourself = true
								returning = true
								leaving = false
								timer = 0
								hasCall4 = true
					
					
					
		else:
			if position.x == -startPosX:
				var whatToDoWithNonPlayer
				whatToDoWithNonPlayer = randi_range(0,1)
				
				returning = whatToDoWithNonPlayer
				leaving = !returning
				
				if !returning:
					print("non-player target abducted, deleting")
					target.queue_free()
					self.queue_free()
				else:
					print("  MOB  RETURNING!")
	
	

func toggleBeamEffects():
	isBeamEnabled = !isBeamEnabled
	
	if isBeamEnabled:
		$BeamSound.play()
		$BeamSprite.show()
		$PointLight2D.show()
	elif !isBeamEnabled:
		$BeamSound.stop()
		$BeamSprite.hide()
		$PointLight2D.hide()
	


var returnTime = 0
var finalBeamTimer = 0
var finalBeaming : bool = false
func returnSanta(delta):
	canecount.is_implanted = true
	$ShipSound.play()
	print("RETURNING SANTA!!!!!")
	print("X: " + str(position.x))
	print("Y: " + str(position.y))
	print("abdX: " + str(abductionPointX))
	print("abdY: " + str(abductionPointY))
	
	
	var newFactor = sin(returnTime * PI * 0.5)
	position.x = lerp(-startPosX, abductionPointX, newFactor)
	
	
	returnTime += delta / 3
	
	if abs(position.x - abductionPointX) <= 2:
		if finalBeaming != true:
			$BeamSprite.speed_scale = 1
			$BeamSprite.play("beaming")
			toggleBeamEffects()
			finalBeaming = true


var leaveFrameCounter = 0
var leaveforgoodtimer = 0
var wasPlayingBefore = false
func leaveForGood(delta):
	leaveFrameCounter += 1
	if not wasPlayingBefore:
		$ShipSprite.play("ship_rotate180")
		wasPlayingBefore = true
	
	if leaveFrameCounter >= 60:
		position.y = lerp(abductionPointY, abductionPointY - 5000, leaveforgoodtimer)
		leaveforgoodtimer += delta / 2
		if leaveforgoodtimer >= 1:
			print("deleting UFO after returning santa")
			self.queue_free()
