extends CharacterBody2D

var jumpsounds := [
	preload("res://sounds/jump/jump1.wav"),
	preload("res://sounds/jump/jump2.wav"),
	preload("res://sounds/jump/jump3.wav"),
	preload("res://sounds/jump/jump4.wav"),
	preload("res://sounds/jump/jump5.wav"),
	preload("res://sounds/jump/jump6.wav"),
]

var secretJumpsounds := [
	preload("res://sounds/secretsounds/exerciseballbounce.wav"),
	preload("res://sounds/secretsounds/secretjump1.wav"),
	preload("res://sounds/secretsounds/secretjump2.wav"),
	preload("res://sounds/secretsounds/secretjump3.wav"),
	preload("res://sounds/secretsounds/secretjump10.mp3"),
	preload("res://sounds/secretsounds/secretjump11.mp3"),
	preload("res://sounds/secretsounds/secretjump12.mp3"),
	preload("res://sounds/secretsounds/secretjump13.mp3"),
	preload("res://sounds/secretsounds/secretjump14.mp3"),
	preload("res://sounds/secretsounds/secretjump15.mp3"),
	preload("res://sounds/secretsounds/secretjump16.mp3"),
	preload("res://sounds/secretsounds/secretjump17.mp3"),
	preload("res://sounds/secretsounds/secretjump18.mp3"),
	preload("res://sounds/secretsounds/secretjump19.mp3"),
	preload("res://sounds/secretsounds/secretjump20.mp3"),
	preload("res://sounds/secretsounds/secretjump21.mp3"),
]

var secretLandSounds := [
	preload("res://sounds/secretsounds/secretland1.mp3"),
	preload("res://sounds/secretsounds/secretland2.mp3"),
	preload("res://sounds/secretsounds/secretland3.mp3"),
	preload("res://sounds/secretsounds/secretland4.mp3"),
	preload("res://sounds/secretsounds/secretland5.mp3"),
	preload("res://sounds/secretsounds/secretland6.mp3"),
	preload("res://sounds/secretsounds/secretland7.mp3"),
	preload("res://sounds/secretsounds/secretland8.mp3"),
	preload("res://sounds/secretsounds/secretland9.mp3"),
]

var footSounds := [
	preload("res://sounds/feet/crunch1.wav"),
	preload("res://sounds/feet/crunch2.wav"),
	preload("res://sounds/feet/crunch3.wav"),
	preload("res://sounds/feet/crunch4.wav"),
	preload("res://sounds/feet/crunch5.wav"),
	preload("res://sounds/feet/crunch6.wav"),
	preload("res://sounds/feet/crunch7.wav"),
]

var landSounds := [
	preload("res://sounds/feet/landing2.wav"),
]



var SPEED: float = 400.0
var JUMP_VELOCITY: float = -550.0
var ACCELERATION: float = 4.0
#var AIR_ACCELERATION: float = 4
var GRAVITY : float

var is_boosting = false

@onready var santa = $AnimatedSprite2D
var max_jumps = 3  # Adjusted for triple jump
var jumps_taken = 0
var was_on_floor = true

var unstuck_timer : float = 3.5
var unstuck_label_timer: float = 0
var unstuck_label = null
var jumpnow_label = null

var facing_direction = -1  # -1 for left, 1 for right

var disabled_input = false

var is_updating_animations = true

var landing_velocity_threshold: float = 1300.0  # Define the minimum downward velocity to trigger landing sounds
var landingV = 0

var isBeingAbducted = false

var isOnFire : bool = false
var hasInitialFireCall : bool = false

func _ready():
	if canecount.golden_santa == true:
		santa.play("golden")
		disabled_input = true
		$randomhohoplayer.volume_db = -80
		if get_parent().name == "Testing":
			position.y = position.y -120
	
	if canecount.secretCharacter == true:
		$randomhohoplayer.volume_db = -80
		santa.sprite_frames = load("res://assets/secret character/player_secret.tres")
		santa.texture_filter = TEXTURE_FILTER_NEAREST
		santa.scale.x = 5.75
		santa.scale.y = 5.75
		santa.position.y = -26.316
	
	AudioServer.set_bus_volume_db(1, canecount.audioBus1MaxVolume)
	AudioServer.set_bus_volume_db(2, canecount.audioBus2MaxVolume)
	
	ProjectSettings.set_setting("physics/2d/default_gravity", 980)
	canecount.isIcewallMoving = true
	
	jumpnow_label = $jumpnow
	jumpnow_label.hide()

	if has_node("Camera2D/UILayer/unstuck_label"):
		unstuck_label = get_node("Camera2D/UILayer/unstuck_label")
		unstuck_label.hide()

func unstuckCheck(delta):
	# Update timers for unstuck logic
	
	if disabled_input != true:
		if is_on_floor():
			unstuck_timer = 3.5
			jumpnow_label.hide()
		
		if canecount.allowUnstuck == true:
			unstuck_timer -= delta
			if unstuck_timer <= 0:
				if has_node("Camera2D/UILayer/unstuck_label"):
					unstuck_label = get_node("Camera2D/UILayer/unstuck_label")
					unstuck_label.show()
				jumps_taken = 0
				jumpnow_label.show()
				unstuck_timer = 3.5
				unstuck_label_timer = 2.5

			if unstuck_label_timer > 0:
				unstuck_label_timer -= delta

			if unstuck_label_timer <= 0 and unstuck_label:
				unstuck_label.hide()
				


func _physics_process(delta):
	if canecount.done == true:
		return
	
	GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")
	
	if velocity.y > 2400:
		if position.y > 1000*80:   #for falling deep into the chimney faster and faster
			pass
		else:
			velocity.y = 2400
	
	velocity.y += GRAVITY * delta
	
	canecount.player_y = position.y
	if disabled_input != true:
		is_boosting = Input.is_action_pressed("boost")
		var direction = Input.get_axis("ui_left", "ui_right")


		if direction != 0:
			var target_speed = direction * SPEED
			var accel = ACCELERATION# if is_on_floor() else AIR_ACCELERATION ## enable for air accel
			if is_boosting and is_on_floor():
				accel *= 1.5
				target_speed *= 1.5
			var speed_difference = target_speed - velocity.x
			velocity.x += speed_difference * accel * delta
		elif is_on_floor():
			velocity.x = 0

		# Jumping logic
		if Input.is_action_just_pressed("ui_accept"):
			if is_on_floor() or jumps_taken < max_jumps:
				playRandomJumpSound()
				velocity.y = JUMP_VELOCITY
				jumps_taken += 1
				unstuck_timer = 3.5
				jumpnow_label.hide()
		if (velocity.y < 0) and Input.is_action_just_released("ui_accept"):
				velocity.y = 0;
	
	

	if velocity.y > 20:
		landingV = velocity.y
	# Reset jump count on landing
	if is_on_floor() and not was_on_floor:
		jumps_taken = 0
		
		if canecount.golden_santa == false:
			santa.play("santa_land")
		
		if landingV > landing_velocity_threshold:
			playRandomLandSound()
		elif landingV > 20:
			playRandomFootSound()

	unstuckCheck(delta)
	
	if is_updating_animations:
		update_animation(delta)  # Update the character's animations
	
	if isOnFire:
		if !hasInitialFireCall:
			hasInitialFireCall = true
			
			$Fires/FireAudio.play()
			
			$Fires.show()
	else:
		#no case in which he is extinguished by current gameplay, so no logic for stopping audio
		$Fires.hide()
	
	was_on_floor = is_on_floor()  # Update the was_on_floor flag for the next frame
	move_and_slide()  # Move the character


func disable_physics_and_input():
	disabled_input = true
	velocity = Vector2.ZERO  # Stop movement
	set_physics_process(false)  # This disables the _physics_process function
	if canecount.golden_santa == false:
		santa.play("santa_idle")  # Directly play the idle animation
	is_updating_animations = false

func enable_physics_and_input():
	disabled_input = false
	set_physics_process(true)
	is_updating_animations = true





var defaultFootstepTime : float = 1.0 / 3.0
var footStepTime = defaultFootstepTime
func update_animation(delta):
	
	# Flip sprite based on direction
	facing_direction = sign(velocity.x) if velocity.x != 0 else facing_direction
	santa.flip_h = facing_direction == 1  # Flip when facing right
	$Implant.scale.x = -1 if facing_direction == 1 else 1
	$Fires.scale.x = -facing_direction
	$CollisionShape2D.scale.x = -facing_direction
	if canecount.golden_santa == true:
		return
	
	var on_floor = is_on_floor()
	var anim = santa.animation  # Current animation name
	var sprite_frames = santa.get_sprite_frames()  # Correctly get the SpriteFrames resource
	var last_frame = sprite_frames.get_frame_count(anim) - 1  # Last frame index of the current animation

	
	if anim == "santa_running":
		
		footStepTime -= delta # remove time from footstep timer 
		
		if is_boosting:
			santa.speed_scale = 2.0  # Double the speed
			footStepTime -= delta  #should end up subtracting delta twice, making footsteps happen faster
		else:
			santa.speed_scale = 1.0  # Normal speed
		
		if footStepTime <= 0:
			playRandomFootSound()
			footStepTime = defaultFootstepTime

	if anim != "santa_running":
		santa.speed_scale = 1.0
	# When on the floor, decide between running and idle
	if on_floor:
		if velocity.x != 0 and anim != "santa_running":
			santa.play("santa_running")
			
		elif velocity.x == 0 and anim != "santa_idle" and anim != "santa_land":
			santa.play("santa_idle")


	# Handle jumping and falling animations
	if not on_floor:
		if velocity.y < 0:  # Going up
			if anim != "santa_jump" and anim != "santa_up":
				santa.play("santa_jump")
			elif anim == "santa_jump" and santa.frame == last_frame:
				santa.play("santa_up")
		elif velocity.y > 0:  # Going down
			if anim != "santa_fall" and anim != "santa_down":
				santa.play("santa_fall")
			elif anim == "santa_fall" and santa.frame == last_frame:
				santa.play("santa_down")

	# Handle landing animation transition to idle
	if on_floor and anim == "santa_land" and santa.frame == last_frame:
		santa.play("santa_idle")


	# Ensure the animation for landing is played once when the character hits the ground
	if on_floor and was_on_floor == false and anim != "santa_land":
		santa.play("santa_land")

	# Store the on_floor status for the next frame
	was_on_floor = on_floor

func playRandomJumpSound():
	var selectedJumpSound
	if canecount.secretCharacter == true:
		selectedJumpSound = secretJumpsounds.pick_random()
		$jumpingsoundplayer.pitch_scale = randf_range(0.8,1.2)
	else:
		selectedJumpSound = jumpsounds.pick_random()
	$jumpingsoundplayer.set_stream(selectedJumpSound)
	$jumpingsoundplayer.play()


func playRandomLandSound():
	var selectedLandSound
	if canecount.secretCharacter == true:
		selectedLandSound = secretLandSounds.pick_random()
	else:
		selectedLandSound = landSounds.pick_random()
	$landingsoundplayer.pitch_scale = randf_range(0.8, 1.2)
	$landingsoundplayer.set_stream(selectedLandSound)
	$landingsoundplayer.play()

var useFirstPlayer = true
func playRandomFootSound():
	var selectedFootSound = footSounds.pick_random()
	var selectedAudioPlayer
	
	# Determine which audio player to use based on the flag
	if useFirstPlayer:
		selectedAudioPlayer = $foot1
	else:
		selectedAudioPlayer = $foot2
		
	if canecount.golden_santa == true:
		selectedFootSound = load("res://sounds/goldland.mp3")
	# Configure and play the sound on the selected audio player
	selectedAudioPlayer.pitch_scale = randf_range(0.8, 1.2)  # Note: It's rand_range, not randf_range. Correcting in case it was a typo.
	selectedAudioPlayer.stream = selectedFootSound
	selectedAudioPlayer.play()
	
	# Toggle the flag for the next footstep
	useFirstPlayer = !useFirstPlayer
