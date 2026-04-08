extends AudioStreamPlayer

var unmute = preload("res://sounds/clicking/punch1.wav")
var mute = preload("res://sounds/clicking/punch5.wav")
var hover = preload("res://sounds/clicking/eat2.wav")

var music

func cookieMute():
	globalmute.isMuted = true
	AudioServer.set_bus_mute(1, true)
	AudioServer.set_bus_mute(2, true)
	self.set_stream(mute)
	self.play()

func cookieUnmute():
	globalmute.isMuted = false
	AudioServer.set_bus_mute(1, false)
	AudioServer.set_bus_mute(2, false)
	self.set_stream(unmute)
	self.play()


#func _on_b_cookie_mouse_entered():
	#if globalmute.isMuted == false:
		#self.set_stream(hover)
		#self.play()
