extends AudioStreamPlayer

var hohos := [
	preload("res://sounds/hohoho/hohoho1.wav"),
	preload("res://sounds/hohoho/hohoho2.wav"),
	preload("res://sounds/hohoho/hohoho3.wav"),
	preload("res://sounds/hohoho/hohoho4.wav"),
	preload("res://sounds/hohoho/hohoho5.wav"),
]

# Called when the node enters the scene tree for the first time.
func _ready():
	$hohotimer.wait_time = randi_range(5, 33)
	$hohotimer.start()

func _on_hohotimer_timeout():
	var h = hohos.pick_random()
	self.set_stream(h)
	if globalmute.isMuted == false:
		self.play()
	$hohotimer.wait_time = randi_range(5, 33)
	$hohotimer.start()
