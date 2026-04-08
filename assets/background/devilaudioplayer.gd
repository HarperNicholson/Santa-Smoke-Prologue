extends AudioStreamPlayer

var devilsounds := [
	preload("res://sounds/devil/devil1.wav"),
	preload("res://sounds/devil/devil2.wav"),
	preload("res://sounds/devil/devil3.wav"),
	preload("res://sounds/devil/devil4.wav"),
	preload("res://sounds/devil/devil5.wav"),
	preload("res://sounds/devil/devil6.wav"),
	preload("res://sounds/devil/devil7.wav"),
	preload("res://sounds/devil/devil8.wav"),
	preload("res://sounds/devil/devil9.wav"),
	preload("res://sounds/devil/devil10.wav"),
	preload("res://sounds/devil/devil11.wav"),
	preload("res://sounds/devil/devil12.wav"),
	preload("res://sounds/devil/devil13.wav"),
	preload("res://sounds/devil/devil14.wav"),
	preload("res://sounds/devil/devil15.wav"),
]


# Called when the node enters the scene tree for the first time.
func playRandomDevilSound():
	var h = devilsounds.pick_random()
	self.set_stream(h)
	self.play()
	

func playHehehe():
	var ehe = devilsounds[6]
	self.set_stream(ehe)
	self.play()
