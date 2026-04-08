extends Node2D

var spawnNumber : int

var caneValue : int
var caneType : String

# Called when the node enters the scene tree for the first time.
func _ready():
	spawnNumber = randi_range(1, 11)
	if spawnNumber >= 1 && spawnNumber <= 5:
		caneValue = 1
		caneType = "candycane"
		$AnimatedSprite2D.play(caneType)
	elif spawnNumber >= 6 && spawnNumber <= 8:
		caneValue = 2
		caneType = "red_vs_blu_cane"
		$AnimatedSprite2D.play(caneType)
	elif spawnNumber == 9 || spawnNumber == 10:
		caneValue = 3
		caneType = "embercane"
		$AnimatedSprite2D.play(caneType)
	elif spawnNumber == 11:
		caneValue = 5
		caneType = "rainbowcane"
		$AnimatedSprite2D.play(caneType)
	else:
		caneValue = 0
		caneType = "nullcane"
		$AnimatedSprite2D.play(caneType)

func _on_body_entered(body):
	if body.name == ("SantaPlayer"):
		canecount.canes += caneValue
		canecount.lastCaneType = caneType
		get_tree().call_group("Audioplayers", "playRandomCanesound")
		self.queue_free()
