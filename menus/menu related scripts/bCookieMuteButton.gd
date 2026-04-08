extends TextureButton
func _ready():
	if globalmute.isMuted == true:
		self.hide()
	else:
		self.show()

func _on_pressed():
	get_tree().call_group("Audioplayers", "cookieMute")
	$"../bCookieUnmute".visible = !$"../bCookieUnmute".visible
	self.visible = !self.visible
