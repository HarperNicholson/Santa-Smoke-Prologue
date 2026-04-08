extends Node2D

var timer : float = 0
var initialWait : float = 0
var initialWaiting : bool = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if canecount.is_implanted:
		if initialWaiting:
			initialWait += delta / 3 #wait 4 seconds before blinking
		
		if initialWait >= 1:
			initialWaiting = false
			timer += delta
			
			if self.visible == true:
				if timer >= 0.2:
					self.visible = !self.visible
					timer = 0
			if self.visible == false:
				if timer >= 0.8:
					self.visible = !self.visible
					timer = 0
