extends Node

var canes = 0
var lastCaneType : String

var totalRows = 0 #pregenerated number of rows

var player_y: float
var player_highest_y = INF  # Very high value
var player_lowest_y = -INF

var m : int

var allowUnstuck

var itsSanta : bool = false
var santaUsername : String
var hasAppliedSantaUser : bool = false

var isIcewallMoving : bool = true

var is_implanted : bool = false

var audioBus1MaxVolume = AudioServer.get_bus_volume_db(1)
var audioBus2MaxVolume =  AudioServer.get_bus_volume_db(2)

var haha = false

var audioPosMoon : float = 200

var golden_santa : bool = false
var secretCharacter : bool = false

var elfIsAblazeIRepeatElfIsAblaze = false

var santaSmoke : bool = false
var done : bool = false


func resetVars():
	canes = 0

	totalRows = 0 #pregenerated number of rows

	player_highest_y = INF  # Very high value
	player_lowest_y = -INF

	itsSanta = false
	hasAppliedSantaUser = false

	isIcewallMoving = true

	is_implanted  = false

	audioBus1MaxVolume = AudioServer.get_bus_volume_db(1)
	audioBus2MaxVolume =  AudioServer.get_bus_volume_db(2)

	haha = false

	audioPosMoon = 200

	golden_santa = false
	secretCharacter = false

	elfIsAblazeIRepeatElfIsAblaze = false

	santaSmoke = false
	done = false


func resetSantaName():
	itsSanta = false
	santaUsername = ""
	hasAppliedSantaUser = false

func _physics_process(_delta):
	if player_y < (player_highest_y - 80):
		player_highest_y = player_y
	if player_y > player_lowest_y:
		player_lowest_y = player_y
	
	if m > 999:
		isIcewallMoving = false
