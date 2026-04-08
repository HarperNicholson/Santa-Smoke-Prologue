extends PointLight2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var lihttween = get_tree().create_tween()
	lihttween.tween_property(self, "energy", 0, 1)
