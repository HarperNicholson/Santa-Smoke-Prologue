extends CharacterBody2D


# Character physics stuff
@export var ELF_SPEED : float = 550.0
@export var ELF_JUMP_VELOCITY : float = -500.0
@export var ELF_ACCELERATION : float = 2400.0
@export var ELF_AIR_ACCELERATION : float = 2000.0
@export var GRAVITY : float = ProjectSettings.get_setting("physics/2d/default_gravity")

var max_jumps = 2
var jumps = 0

var is_falling = false

# Elf stuff
var random_move_direction = 0  # -1 for left, 0 for idle, 1 for right
var movement_timer = 0.0
var jump_timer = 0.0

const MIN_MOVE_TIME = 0.1
const MAX_MOVE_TIME = 1.5
const MIN_JUMP_INTERVAL = 1.0
const MAX_JUMP_INTERVAL = 3.0

@onready var animated_sprite = $AnimatedSprite2D
@onready var audio_player = $AudioStreamPlayer2D

var facing_direction = -1  # -1 for left, 1 for right

var scream: AudioStreamPlayer2D

# Timing and target values for pitch and volume interpolation
var pitch_duration : float = 0.0
var volume_duration : float = 0.0

var target_pitch_scale : float = 1.0
var target_volume_db : float

var elapsed_pitch_time : float = 0.0
var elapsed_volume_time : float = 0.0

# Min/Max settings for pitch, volume, and their durations
var min_pitch_scale : float = 0.9
var max_pitch_scale : float = 1.3
var min_volume_db : float = -80
var max_volume_db : float = 10

@export var min_pitch_duration : float = 0.1
@export var max_pitch_duration : float = 1.0


@export var min_volume_off_duration : float = 0.1
@export var max_volume_off_duration : float = 0.3
@export var min_volume_on_duration : float = 0.5
@export var max_volume_on_duration : float = 4
@export var volume_lerp_duration : float = 0.3 # Example duration for interpolating volume on/off

var is_volume_off = false
var volume_state_timer : float = 0.0
var current_volume_db : float = min_volume_db # Initial volume state

@export var isOnFire = false

@export var isElfMuted = false

var isBeingAbducted = false
# Modify the _ready function to initialize volume state
func _ready():
	if isElfMuted:
		$AudioStreamPlayer2D.stop()
		$AudioStreamPlayer2D.volume_db = -80
		$Label.hide()
	
	scream = $AudioStreamPlayer2D
	
	reset_movement_timer()
	reset_jump_timer()

func randomize_volume_state():
	if !isElfMuted:
		if is_volume_off:
			# Switching to volume on
			target_volume_db = max_volume_db
			volume_state_timer = randf_range(min_volume_on_duration, max_volume_on_duration)
		else:
			# Switching to volume off
			target_volume_db = min_volume_db
			volume_state_timer = randf_range(min_volume_off_duration, max_volume_off_duration)
		is_volume_off = !is_volume_off
		elapsed_volume_time = 0.0 # Reset the timer for volume lerp

func randomize_pitch():
	if !isElfMuted:
		target_pitch_scale = randf_range(min_pitch_scale, max_pitch_scale) * (1.8 if name == "RedElf" else 1.0)
		pitch_duration = randf_range(min_pitch_duration, max_pitch_duration)
		elapsed_pitch_time = 0.0



func reset_movement_timer():
	movement_timer = randf_range(MIN_MOVE_TIME, MAX_MOVE_TIME)

func reset_jump_timer():
	jump_timer = randf_range(MIN_JUMP_INTERVAL, MAX_JUMP_INTERVAL)

var hasInitialFireCall = false

var disabled_input = false

func _physics_process(delta):
	if isOnFire:
		if !hasInitialFireCall:
			hasInitialFireCall = true
			
			if !isElfMuted:
				randomize_pitch()
				randomize_volume_state()
				
				$Fires/FireAudio.play()
			
			$Fires.show()
			if get_parent().name != "ChimneyLevel":
				canecount.elfIsAblazeIRepeatElfIsAblaze = true
		
		
		#scream timers etc
			# Handle pitch scale interpolation
		
		if !isElfMuted:
			if elapsed_pitch_time < pitch_duration:
				elapsed_pitch_time += delta
				var pitch_t = elapsed_pitch_time / pitch_duration
				scream.pitch_scale = lerp(scream.pitch_scale, target_pitch_scale, pitch_t)
				
				if elapsed_pitch_time >= pitch_duration:
					randomize_pitch()
			
		
		
		
		if !isElfMuted:
			if elapsed_volume_time < volume_state_timer:
					elapsed_volume_time += delta
					var volume_t = min(elapsed_volume_time / volume_lerp_duration, 1.0) # Ensure t does not exceed 1
					scream.volume_db = lerp(current_volume_db, target_volume_db, volume_t)
					
					if elapsed_volume_time >= volume_state_timer:
						current_volume_db = target_volume_db # Update current volume to the target
						randomize_volume_state() # Prepare for the next state transition
		
	elif !isOnFire:
		hasInitialFireCall = false

	
	
	
	
	if not disabled_input:
		velocity.y += GRAVITY * delta

		# Update timers
		movement_timer -= delta
		if is_on_floor():
			jump_timer -= delta
		else:
			jump_timer -= delta * 4  # Faster decrement when in air

		# Handle random movement direction change
		if movement_timer <= 0:
			random_move_direction = randi() % 3 - 1  # -1, 0, or 1
			reset_movement_timer()

		# Handle random jumping
		if jump_timer <= 0:
			random_jump()
			reset_jump_timer()

		# Movement logic
		var accel = ELF_ACCELERATION if is_on_floor() else ELF_AIR_ACCELERATION
		if random_move_direction != 0:
			velocity.x = move_toward(velocity.x, random_move_direction * ELF_SPEED, accel * delta)
		elif is_on_floor():
			velocity.x = move_toward(velocity.x, 0, ELF_ACCELERATION * delta)

		# Apply movement
		move_and_slide()

		# Reset jump count on landing
		if is_on_floor():
			jumps = 0
	
	update_animation()
	
	
	
	
	
	
	

func random_jump():
	if jumps < max_jumps:
		velocity.y = ELF_JUMP_VELOCITY
		jumps += 1

# Additional logic for animation (to be implemented later)
func update_animation():
	if velocity.x != 0 or not is_on_floor():
		animated_sprite.animation = "elf_running"
		# Update facing direction based on velocity if moving
		if velocity.x != 0:
			facing_direction = sign(velocity.x)  
		animated_sprite.flip_h = facing_direction == 1
		$Fires.scale.x = -facing_direction
	else:
		animated_sprite.animation = "elf_idle"
