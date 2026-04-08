extends Sprite2D

#set base to 90 and max = base * 1.9
@export var base_speed : float = 90
var max_speed : float

var hasEntered : bool = false #ensures game over can only be triggered once


@export var allowTweening : bool = true

var blahs := [
	preload("res://sounds/blah/blah1.wav"),
	preload("res://sounds/blah/blah2.wav"),
	preload("res://sounds/blah/blah3.wav"),
	preload("res://sounds/blah/blah4.wav"),
	preload("res://sounds/blah/blah5.wav"),
	preload("res://sounds/blah/blah6.wav"),
	preload("res://sounds/blah/blah7.wav"),
	preload("res://sounds/blah/blah8.wav"),
	preload("res://sounds/blah/blah9.wav"),
	preload("res://sounds/blah/blah10.wav"),
	preload("res://sounds/blah/blah11.wav"),
	preload("res://sounds/blah/blah12.wav"),
	preload("res://sounds/blah/blah13.wav"),
]

var startpos
var endpos

@export var xDifference = 100

var tween_duration: float = 4  # Duration in seconds
var tweening_to_startpos: bool = false

func _ready():
	max_speed = base_speed * 1.9
	startpos = position.x
	endpos = position.x + xDifference  # Assuming you only want to change the x component
	if allowTweening == true:
		tween_to_position(endpos)

func tween_to_position(target_pos):
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position:x", target_pos, tween_duration)
	$POSTIMER.start()

func _on_postimer_timeout():
	tweening_to_startpos = not tweening_to_startpos
	var nextpos = startpos if tweening_to_startpos else endpos
	tween_to_position(nextpos)
	$POSTIMER.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if canecount.isIcewallMoving == true:
		$draggingsound.volume_db = 0
	else:
		$draggingsound.volume_db = -80
	
	var caneSpeedBonus : float = (max_speed - base_speed) * (canecount.canes / 100.0)
	var heightSpeedBonus : float = (max_speed - base_speed)  *  ( ( ( (canecount.player_y - 678) / 80)*-1) / 100)
	var current_speed : float = base_speed + ((caneSpeedBonus + heightSpeedBonus) / 3)
	current_speed = min(current_speed, max_speed) * int(canecount.isIcewallMoving)
	
	if canecount.canes == 0 and get_parent().name == "Testing": 
		current_speed = 70 * int(canecount.isIcewallMoving)
	
	position.y -= current_speed * delta
	


func _on_area_2d_body_entered(body):
	if body.name == ("SantaPlayer") && hasEntered == false:
		if get_parent().name == "Intro":
			canecount.haha = true
		hasEntered = true
		freeze(body)
		get_tree().call_group("blackOverlay", "fade_in")
		$iceAudioPlayer.play()
		$Timer.start()
		$"../killtimer".start()
	elif body.is_in_group("freezeable"):
		freeze(body)

func freeze(body):
	
	for child in body.get_children():
		# Check if the child is an AnimatedSprite2D
		if child is AnimatedSprite2D:
			child.stop()
			child.modulate = Color.DEEP_SKY_BLUE
		
		# Check if the child is an AudioStreamPlayer
		if child is AudioStreamPlayer:  #santa's audio
			child.stop()
		
		
		if child is AudioStreamPlayer2D:   #mob audio
			var blah = blahs.pick_random()
			child.set_stream(blah)
			child.play()
		
		if child is Node2D:
			for node2DChild in child.get_children():
				if node2DChild is AnimatedSprite2D:
					node2DChild.stop()
					node2DChild.modulate = Color.DEEP_SKY_BLUE
					
					
				
				
			
			
		
	
	# Freeze the object's position
	body.set_physics_process(false)



func _on_timer_timeout():
	if get_parent().name == "Intro":
		get_tree().reload_current_scene()
	else:
		canecount.resetSantaName()
		get_tree().change_scene_to_file("res://menus/deathscreen_layer.tscn")


func _on_platform_culling_body_entered(body):
	if body.is_in_group("cullable"):
		body.queue_free()


func _on_platform_culling_area_entered(area):
	if area.is_in_group("cullable"):
		area.queue_free()
