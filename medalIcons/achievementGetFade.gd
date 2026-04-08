extends Node2D

@export var medalDisplayName : String = "MEDAL_NAME"
@export var medalIconPath : String = "icon path"

func _ready():
	self.hide()
	$MedalIconSprite.texture = load(medalIconPath)
	$DynamicText.text = str(medalDisplayName)
	fade_in()

func fade_in():
	self.show()
	$AudioStreamPlayer.play()
	modulate = Color(modulate.r, modulate.g, modulate.b, 0)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate",
						 Color(modulate.r, modulate.g, modulate.b, 1), # End alpha
						 0.5)
	$Timer.start()

func fade_out():
	modulate = Color(modulate.r, modulate.g, modulate.b, 1)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate",
						 Color(modulate.r, modulate.g, modulate.b, 0), # End alpha
						 0.5)
	tween.tween_callback(
		func():
		print("q free achievement get")
		queue_free()
		)

func _on_timer_timeout():
	fade_out()
