extends StaticBody2D

func _process(_delta):
	if canecount.player_y > 666*80 and canecount.player_y > position.y + 2000:
		self.queue_free()
