extends Node2D

var windsounds := [
	preload("res://sounds/wind/wind1.wav"),
	preload("res://sounds/wind/wind2.wav"),
	preload("res://sounds/wind/wind3.wav"),
	preload("res://sounds/wind/wind4.wav"),
	preload("res://sounds/wind/wind5.wav"),
	preload("res://sounds/wind/wind6.wav"),
]


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time = randi_range(3, 15)
	$Timer.start()

func _on_timer_timeout():
	var selectedWindsound = windsounds.pick_random()
	print("Selected sound: ", selectedWindsound)
	$AudioStreamPlayer.set_stream(selectedWindsound)
	if globalmute.isMuted == false:
		$AudioStreamPlayer.play()
	$Timer.wait_time = randi_range(5, 30)
	$Timer.start()
