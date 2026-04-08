extends Node2D

var reverb_effect_index = 0
var master_bus_index

var lastM

var min_volume_db = -80.0
var max_volume_db = 11.0

var elfmaxvoldb = 9.0


var last_player_y_at_wall_generated = 0


var wall = preload("res://assets/chimney/c_level_wall.tscn")
var wallLastZ = -1

var offset_y = 962.82

var preloadLand = preload("res://sounds/feet/landing2.wav")

var hasCalled = false
var smoke









func _ready():
	canecount.allowUnstuck = true
	
	
	
	smoke = $SantaPlayer/Smokelayer/SmokeSprite
	
	var bus_index = AudioServer.get_bus_index("Master")
	# Create a new effect instance (e.g., a reverb effect)
	var effect = AudioEffectReverb.new()
	# Flag to check if the effect already exists
	var effect_exists = false

	# Get the number of effects on the bus
	var num_effects = AudioServer.get_bus_effect_count(bus_index)

	# Iterate through the effects to check if the effect already exists
	for i in range(num_effects):
		var existing_effect = AudioServer.get_bus_effect(bus_index, i)
		# Check if the existing effect is of the same type as the one we want to add
		if existing_effect is AudioEffectReverb:
			effect_exists = true
			break

	# If the effect does not exist, add it to the bus
	if not effect_exists:
		AudioServer.add_bus_effect(bus_index, effect)
	
	last_player_y_at_wall_generated = canecount.player_lowest_y
	
	#pregenerate to keep a buffer zone, avoids visible generation
	generateWall()





#for smoke effect
var start_height : float = -250
var end_height : float = -900

func _process(_delta):
	var m = canecount.m
	# Check if the player has descended another 1330 units since the last wall was generated
	if canecount.player_lowest_y - last_player_y_at_wall_generated >= 1000:
		generateWall()
	if canecount.m == -666:
		canecount.allowUnstuck = false
		$SantaPlayer/Camera2D/UILayer/unstuck_label.hide()
		$SantaPlayer/jumpnow.hide()
		$SantaPlayer.jumps_taken = 3
		achievements.unlock_achievement("DESCENT")
	if m < -1200 and not hasCalled:
		hasCalled = true
		exitToHell()
	
	
	
	if m < start_height and m > end_height:
		# Calculate the progress ratio between start_height and end_height
		var progress : float = (float(m) - start_height) / (end_height - start_height)
		
		# Ensure the alpha is between 0 and 1
		var alpha : float = clamp(progress, 0.0, 1.0)
		# Apply the alpha to the smoke sprite
		smoke.modulate.a = alpha
	elif m <= end_height:
		# Ensure the sprite is fully visible if the player is below -1300m
		smoke.modulate.a = 1.0
	elif m >= start_height:
		# Ensure the sprite is invisible if the player is above -500m
		smoke.modulate.a = 0.0
		
		
		
		
		
		
		
		
	
	
	
	
	

	
	
	update_ambient_volume()

func update_ambient_volume():
	# Calculate normalized height directly, suitable for linear interpolation
	var normalized_height = (-canecount.m + 430) / 1400.0  # Normalize m directly, ensuring 0 maps to 0 and -1000 to 1
	
	# Clamp the normalized height to the range [0, 1] to handle out-of-range values
	normalized_height = clamp(0.0, 1.0, normalized_height)
	# Use the normalized height to interpolate the volume
	var volume_db = lerp(min_volume_db, max_volume_db, normalized_height)
	
	$ChimneyAudio/FireSounds.volume_db = volume_db
	$ChimneyAudio/FireSounds2.volume_db = volume_db / 1.3
	#
	#var elfvoldb = lerp(min_volume_db, elfmaxvoldb, normalized_height)
	#$ChimneyAudio/AudioStreamPlayer.volume_db = elfvoldb







func generateWall():
	var new_wall = wall.instantiate()
	new_wall.z_index = wallLastZ -2
	wallLastZ -= 1
	# Set the new wall's position. Adjust the calculation based on your game's logic.
	# Here, we use the player's current lowest y position minus a fixed offset to place the new wall.
	new_wall.position = Vector2(0, offset_y)
	add_child(new_wall)
	offset_y += 1330
	# Update the last_player_y_at_wall_generated to the current player_lowest_y position
	last_player_y_at_wall_generated = canecount.player_lowest_y





func exitToHell():
	fade_in()
	$LandTimer.start()

func _on_land_timer_timeout():
	$ChimneyAudio/FireSounds.stop()
	$ChimneyAudio/FireSounds2.stop()
	$AmbientScreamerElf.queue_free()
	$AmbientScreamerElf2.queue_free()
	$ChimneyAudio/FireSounds.set_stream(preloadLand)
	$ChimneyAudio/FireSounds.volume_db = -6.0
	$ChimneyAudio/FireSounds.play()

func fade_in(duration: float = 0.4):
	var tween = get_tree().create_tween()
	tween.tween_property($SantaPlayer/fuckyoulayer/Sprite2D, "modulate",
						 Color(modulate.r, modulate.g, modulate.b, 1), # End alpha
						 duration)
	$Timer.start()


func _on_timer_timeout():
	get_tree().change_scene_to_file("res://assets/background/newHell.tscn")


func _on_fire_sounds_2_timer_timeout():
	$ChimneyAudio/FireSounds2.play()
