extends Node2D

var snow_scene : PackedScene = preload("res://assets/overlay/overlay_finesnow.tscn")
var snowtimer : PackedScene = preload("res://assets/overlay/finesnow_timer.tscn")
var snowtimer_instance : Node  # Change the type to Node

var overlay : int = 1
var snow_instance : Node  # Change the type to Node

# Called when the node enters the scene tree for the first time.
func _ready():
	snowtimer_instance = snowtimer.instantiate()
	self.add_child(snowtimer_instance)
	snowtimer_instance.timeout.connect(_on_Timer_timeout)

func _process(_delta):
	for i in range(overlay):
		overlay -= 1
		snow_instance = snow_scene.instantiate()  # Use the instance() method to create an instance
		self.add_child(snow_instance)

func _on_Timer_timeout():
	overlay += 1
