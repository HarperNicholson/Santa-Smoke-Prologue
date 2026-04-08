extends CanvasLayer

@export var duration: float = 0.8

func fade_on():
	$Sprite2D.modulate = Color($Sprite2D.modulate.r, $Sprite2D.modulate.g, $Sprite2D.modulate.b, 0)
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "modulate",
						 Color($Sprite2D.modulate.r, $Sprite2D.modulate.g, $Sprite2D.modulate.b, 1), # End alpha
						 duration)

func fade_off():
	$Sprite2D.modulate = Color($Sprite2D.modulate.r, $Sprite2D.modulate.g, $Sprite2D.modulate.b, 1)
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "modulate",
						 Color($Sprite2D.modulate.r, $Sprite2D.modulate.g, $Sprite2D.modulate.b, 0), # End alpha
						 duration)
