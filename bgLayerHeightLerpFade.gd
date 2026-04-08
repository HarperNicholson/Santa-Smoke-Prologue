extends CanvasLayer

var atmosphere : Node = null
var hasInstantiatedAtmosphere : bool = false
var maxAtmosphere : bool = false

var space : Node = null
var maxSpace : bool = false

var audioMin : float = -80

var hasCalledForMoon : bool = false
var hasCalledElse : bool = false
var hasCalledForRotate : bool = false

func _ready():
	maxSpace = false
	space = null
	
	atmosphere = null
	hasInstantiatedAtmosphere = false
	maxAtmosphere = false
	
	canecount.m = 0

func _process(_delta):
	if canecount.m > 333 and not hasInstantiatedAtmosphere:
		#instantiate and add the atmosphere only once
		atmosphere = load("res://assets/background/bg_atmosphere.tscn").instantiate()
		add_child(atmosphere)
		hasInstantiatedAtmosphere = true
	
	if not maxAtmosphere:
		var aclamped_cane_count = clamp(canecount.m, 333, 620)
		var alerp_value = float(aclamped_cane_count - 333) / (620 - 333)
		$bg_northpole.modulate.a = lerp(1, 0, alerp_value)
		
		$"../overLayer/looping_snow".modulate.a = lerp(1, 0, alerp_value)
		$"../overLayer/overlay_snowdust".modulate.a = lerp(1, 0, alerp_value)
		
		if $bg_northpole.modulate.a <= 0:
			space = load("res://assets/background/bg_space.tscn").instantiate()
			add_child(space)
			$bg_northpole.queue_free()
			$"../overLayer/looping_snow".queue_free()
			$"../overLayer/overlay_snowdust".queue_free()
			maxAtmosphere = true
		
	
	if not maxSpace and maxAtmosphere == true:
		var bclamped_cane_count = clamp(canecount.m, 620, 1000)
		var blerp_value = float(bclamped_cane_count - 620) / (1000 - 620)
		atmosphere.modulate.a = lerp(1, 0, blerp_value)
		
		
		#AudioServer.set_bus_volume_db(1, lerp(canecount.audioBus1MaxVolume, audioMin, blerp_value))
		AudioServer.set_bus_volume_db(2, lerp(canecount.audioBus2MaxVolume, audioMin, blerp_value))
		
		ProjectSettings.set_setting("physics/2d/default_gravity", lerp(980, 327, blerp_value))
		
		if atmosphere.modulate.a <= 0:
			atmosphere.queue_free()
			maxSpace = true
	
	if maxSpace == true and canecount.canes == 0 && not hasCalledForRotate:
		$rotateTweenDelayTimer.start()
		ProjectSettings.set_setting("physics/2d/default_gravity", -666)
		$"../..".disabled_input = true
		canecount.allowUnstuck = false
		achievements.unlock_achievement("WEIGHTLESS")
		hasCalledForRotate = true
	
	
	if canecount.m >= 1200 && not hasCalledForMoon and canecount.canes == 0:
		get_tree().call_group("blackOverlay", "fade_in")
		$moonTimer.start()
		hasCalledForMoon = true
	
	if maxSpace == true and canecount.canes > 0 && not hasCalledElse: 
		$rotateTweenDelayTimer.start()
		$"../..".disabled_input = true
		var projectGravityAlter = ProjectSettings.get_setting("physics/2d/default_gravity")
		ProjectSettings.set_setting("physics/2d/default_gravity", -20)
		canecount.allowUnstuck = false
		$lostInSpaceTimer.start()
		hasCalledElse = true

func spaceRotate():
	#rotate santa sprite 360 in 1 second
	var rotatetween = get_tree().create_tween()
	rotatetween.tween_property($"../../AnimatedSprite2D", "rotation",
						 $"../../AnimatedSprite2D".rotation+4, # End alpha
						 1)
	var rotateimplanttween = get_tree().create_tween()
	rotateimplanttween.tween_property($"../../Implant", "rotation",
						 $"../../Implant".rotation+4, # End alpha
						 1)


func _on_rotate_tween_delay_timer_timeout():
	spaceRotate()

func _on_lost_in_space_timer_timeout():
	$"../NewBlackOverlay".fade_on()
	$FadeTimer.start()

func _on_moon_timer_timeout():
	canecount.audioPosMoon = $"../../../music".get_playback_position() + 3
	get_tree().change_scene_to_file("res://moon.tscn")


func _on_fade_timer_timeout():
	$"../NewBlackOverlay".fade_off()
	$"../UILayer".hide()
	$"../pauseLayer".hide()
	var lostinspace = load("res://menus/lostInSpaceLayer.tscn").instantiate()
	add_child(lostinspace)
