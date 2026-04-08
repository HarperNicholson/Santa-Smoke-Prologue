extends Node2D

var chimneySounds : Array = [
	"res://sounds/chimney/chimney1.wav",
	"res://sounds/chimney/chimney2.wav",
	"res://sounds/chimney/chimney3.wav",
	"res://sounds/chimney/chimney4.wav",
	"res://sounds/chimney/chimney5.wav",
	"res://sounds/chimney/chimney6.wav",
	"res://sounds/chimney/chimney7.wav",
	"res://sounds/chimney/chimney8.wav",
]
var pickedSound

var chimneyDirection


@export var targetScene : String = "res://path/to/your/scene.tscn"
@export var isExit : bool = false

func _ready():
	pickedSound = load(chimneySounds.pick_random())
	print(str(pickedSound))
	$AudioStreamPlayer.set_stream(pickedSound)
	
	chimneyDirection = 1 if position.x > 160 else -1
	$Sprite2D.flip_h = 1 if position.x > 160 else 0
	
	$Blocker.collision_layer  = 2

func _on_area_2d_body_entered(body):
	if body.name == "SantaPlayer":
		body.disable_physics_and_input()
		if isExit:
			chimneyDirection = -chimneyDirection  # Flip the direction for exiting
		
		
		var tween = get_tree().create_tween()
		tween.tween_property(
			body, 
			"position", 
			body.position + Vector2(120 * chimneyDirection, 0),
			1.0)
		
		$AudioStreamPlayer.pitch_scale = randf_range(0.9, 1.1)
		$AudioStreamPlayer.play()
		$TimerTimer.start()
		if get_parent().name == "newHell":
			get_parent().chimneyAchieveyFinal()
	if body.is_in_group("cullable"):
		body.queue_free()

func _on_area_2d_body_exited(body):
	if body.name == "SantaPlayer":
		$Blocker.collision_layer  = 1
		body.enable_physics_and_input()
		$TimerTimer.stop()




func _on_timer_timer_timeout():
	get_tree().call_group("blackOverlay", "fade_in")
	$LoadTimer.start()


func _on_load_timer_timeout():
	get_tree().change_scene_to_file(targetScene)
