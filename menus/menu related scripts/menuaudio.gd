extends AudioStreamPlayer

var hover = preload("res://sounds/clicking/eat2.wav")
var click = preload("res://sounds/clicking/eat3.wav")


func _on_butt_credits_mouse_entered():
	if (globalmute.isMuted == false):
		self.set_stream(hover)
		self.play()
func _on_butt_credits_pressed():
	if (globalmute.isMuted == false):
		self.set_stream(click)
		self.play()


func _on_play_mouse_entered():
	if (globalmute.isMuted == false):
		self.set_stream(hover)
		self.play()
func _on_play_pressed():
	if (globalmute.isMuted == false):
		self.set_stream(click)
		self.play()


func _on_notetothorbutton_mouse_entered():
	if (globalmute.isMuted == false):
		self.set_stream(hover)
		self.play()
func _on_notetothorbutton_pressed():
	if (globalmute.isMuted == false):
		self.set_stream(click)
		self.play()


func _on_back_mouse_entered():
	if (globalmute.isMuted == false):
		self.set_stream(hover)
		self.play()
func _on_back_pressed():
	if (globalmute.isMuted == false):
		self.set_stream(click)
		self.play()


func _on_harpernicholson_mouse_entered():
	if (globalmute.isMuted == false):
		self.set_stream(hover)
		self.play()
func _on_harpernicholson_pressed():
	if (globalmute.isMuted == false):
		self.set_stream(click)
		self.play()

func _on_linktree_mouse_entered():
	if (globalmute.isMuted == false):
		self.set_stream(hover)
		self.play()
func _on_linktree_pressed():
	if (globalmute.isMuted == false):
		self.set_stream(click)
		self.play()
