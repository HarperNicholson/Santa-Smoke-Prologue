extends AnimatedSprite2D

# Define scale ranges
@export var scaleMinX = -1.5
@export var scaleMaxX = 1.5
@export var scaleMinY = 0.5
@export var scaleMaxY = 1.5

@export var scaleFactor = 0.5

var fireballTime

@export var minTime : float = 1.5
@export var maxTime : float = 60.0

@export var volumeDB : float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	clampf(minTime, 2.1, maxTime)
	clampf(maxTime, minTime, maxTime)
	randomizeFireballTime()
	$AudioStreamPlayer2D.volume_db = volumeDB

func randomizeFireballTime():
	fireballTime = randf_range(minTime, maxTime)

func playRandomFireball():
	var randomScaleX = randf_range(scaleMinX, scaleMaxX)
	var randomScaleY = randf_range(scaleMinY, scaleMaxY)
	
	var isScaleXInverted : bool = randi_range(0,1)
	if isScaleXInverted:
		randomScaleX = -randomScaleX
	
	self.scale = Vector2(randomScaleX, randomScaleY) * scaleFactor
	
	play("fireball1")
	
	$AudioStreamPlayer2D.pitch_scale = randf_range(0.8, 1.2)
	$AudioStreamPlayer2D.play()

func _physics_process(delta):
	if fireballTime > 0: fireballTime -= delta
	else: 
		playRandomFireball()
		randomizeFireballTime()
