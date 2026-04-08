extends Sprite2D


func _ready():
	var orbtween = get_tree().create_tween()
	orbtween.tween_property(self, "position:x", -100, 0.6)
	await(get_tree().create_timer(0.6).timeout)
	self.queue_free()
