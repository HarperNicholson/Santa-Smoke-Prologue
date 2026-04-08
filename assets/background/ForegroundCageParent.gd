extends Node2D

var startpos
var endpos

@export var xDifference = 15
@export var tween_duration: float = 2.5  # Duration in seconds
var tweening_to_startpos: bool = false

var toStartSounds : Array = [
	preload("res://sounds/cage/toStart1.mp3"),
	preload("res://sounds/cage/toStart2.mp3")
]

var toEndSounds : Array = [
	preload("res://sounds/cage/toEnd1.mp3"),
	preload("res://sounds/cage/toEnd2.mp3"),
	preload("res://sounds/cage/toEnd3.mp3")
]

var hasAudioPlayer : bool = false

func _ready():
	if get_child(0) == $AmbientCreakingAudioStreamPlayer2D:
		hasAudioPlayer = true
	randomize()  # Ensure random values each run
	startpos = position.x
	endpos = position.x + xDifference  # Assuming you only want to change the x component
	var initial_position = position.x
	tween_to_position(endpos if initial_position > (startpos + endpos) / 2 else startpos)
	start_independent_tweening()

func start_independent_tweening():
	while true:
		await get_tree().create_timer(tween_duration).timeout  # Wait for a random time
		var nextpos = startpos if tweening_to_startpos else endpos
		tween_to_position(nextpos)
		tweening_to_startpos = !tweening_to_startpos
		if hasAudioPlayer == true:
			if tweening_to_startpos:
				$AmbientCreakingAudioStreamPlayer2D.set_stream(toStartSounds.pick_random())
				$AmbientCreakingAudioStreamPlayer2D.pitch_scale = randf_range(0.8,1.2)
				$AmbientCreakingAudioStreamPlayer2D.play()
			else:
				$AmbientCreakingAudioStreamPlayer2D.set_stream(toEndSounds.pick_random())
				$AmbientCreakingAudioStreamPlayer2D.pitch_scale = randf_range(0.8,1.2)
				$AmbientCreakingAudioStreamPlayer2D.play()

func tween_to_position(target_pos):
	
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position:x", target_pos, tween_duration)
