extends Sprite2D

var initDuration := 0.9

func _ready():
	# Set initial state of the sprite (hidden)
	$"..".show()
	$"../loadingScreenElements".hide()
	modulate = Color(modulate.r, modulate.g, modulate.b, 1)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate",
						 Color(modulate.r, modulate.g, modulate.b, 0), # End alpha
						 initDuration)

func fade_in(duration: float = 0.9):
	modulate = Color(modulate.r, modulate.g, modulate.b, 0)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate",
						 Color(modulate.r, modulate.g, modulate.b, 1), # End alpha
						 duration)
	$"../Timer".start()

func fade_out(duration: float = 0.9):
	$"../loadingScreenElements".hide()
	modulate = Color(modulate.r, modulate.g, modulate.b, 1)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate",
						 Color(modulate.r, modulate.g, modulate.b, 0), # End alpha
						 duration)


func _on_timer_timeout():
	$"../loadingScreenElements".show()
