extends Node2D

var platformTypes := [
	preload("res://assets/platforms/snow/sp1a.tscn"), 
	preload("res://assets/platforms/snow/sp1b.tscn")
	]

# Called when the node enters the scene tree for the first time.
func _ready():
	var pickedPlatform = platformTypes.pick_random()
	var platformInstance = pickedPlatform.instantiate()
	add_child(platformInstance)
