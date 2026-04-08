extends Node2D

var reverb_effect_index = 0
var master_bus_index

var gameMusic = preload("res://sounds/music/cracktrap.mp3")
var m
# Called when the node enters the scene tree for the first time.
func _ready():
	canecount.isIcewallMoving = true
	canecount.allowUnstuck = true
	canecount.is_implanted = false
	
	get_tree().call_group("blackOverlay", "fade_out")
	$music.set_stream(gameMusic)
	if globalmute.isMuted:
		AudioServer.set_bus_mute(2, true)
	else:
		AudioServer.set_bus_mute(2, false)
	$music.play()
	canecount.canes = 0
	canecount.lastCaneType = "nullcane"
	call_deferred("remove_effect")

func remove_effect():
	var bus_index = AudioServer.get_bus_index("Master")
	var effect_index = 0 # Adjust this index based on the effect you want to remove
	AudioServer.remove_bus_effect(bus_index, effect_index)




func _on_killtimer_timeout():
	for child in get_children():
		child.queue_free()
		
	
	var x = load("res://menus/deathscreen_layer.tscn").instantiate()
	add_child(x)



func _on_button_pressed():
	canecount.canes = 0
	$SantaPlayer/Camera2D/UILayer/buttonsound.play()
