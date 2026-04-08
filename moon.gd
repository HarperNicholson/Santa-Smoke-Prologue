extends Node2D

func _ready():
	ProjectSettings.set_setting("physics/2d/default_gravity", 300)
	canecount.allowUnstuck == false
	$AudioStreamPlayer2D.play(canecount.audioPosMoon)
