extends CharacterBody2D


# Character physics stuff
@export var ELF_SPEED : float = 200.0
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
const MAX_MOVE_TIME = 2.5
const MIN_JUMP_INTERVAL = 1.0
const MAX_JUMP_INTERVAL = 3.0

@onready var animated_sprite = $AnimatedSprite2D

var facing_direction = -1  # -1 for left, 1 for right

var isBeingAbducted = false

func _ready():
	reset_movement_timer()
	reset_jump_timer()

func reset_movement_timer():
	movement_timer = randf_range(MIN_MOVE_TIME, MAX_MOVE_TIME)

func reset_jump_timer():
	jump_timer = randf_range(MIN_JUMP_INTERVAL, MAX_JUMP_INTERVAL)

var disabled_input = false

func _physics_process(delta):
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
		animated_sprite.animation = "gt_march"
		# Update facing direction based on velocity if moving
		if velocity.x != 0:
			facing_direction = sign(velocity.x)  
		animated_sprite.flip_h = facing_direction == -1
	else:
		animated_sprite.animation = "gt_idle"
