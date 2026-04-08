extends Node2D

func _ready():
	$CPUParticles2D.emitting = true

func _on_body_entered(body):
	if body.name == ("SantaPlayer"):
		$AnimatedSprite2D.hide()
		$AudioStreamPlayer.play()
		canecount.santaSmoke = true
		self.queue_free()
