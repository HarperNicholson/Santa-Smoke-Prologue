extends TextureButton
func _ready():
	if globalmute.isMuted == false:
		self.hide()
	else:
		self.show()

func _on_pressed():
	get_tree().call_group("Audioplayers", "cookieUnmute")
	$"../bCookie".visible = !$"../bCookie".visible
	self.visible = !self.visible
