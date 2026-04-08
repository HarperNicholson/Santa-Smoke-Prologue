extends AudioStreamPlayer

var eat_sounds := [
	preload("res://sounds/candy/eat1.wav"),
	preload("res://sounds/candy/eat2.wav"),
	preload("res://sounds/candy/eat3.wav"),
	preload("res://sounds/candy/eat4.wav"),
	preload("res://sounds/candy/eat5.wav"),
	preload("res://sounds/candy/eat6.wav"),
	preload("res://sounds/candy/eat7.wav"),
	preload("res://sounds/candy/eat8.wav"),
	preload("res://sounds/candy/eat9.wav"),
	preload("res://sounds/candy/eat10.wav"),
	preload("res://sounds/candy/eat11.wav")
]

func playRandomCanesound():
	if not globalmute.isMuted:
		var selectedSound = eat_sounds.pick_random()
		self.set_stream(selectedSound)
		self.pitch_scale = randf_range(0.9, 1.1)
		self.play()
