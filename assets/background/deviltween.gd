extends Sprite2D


var startpoint
var endpoint
@export var distance : int = 100

var toStart : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	startpoint = self.position.y
	endpoint = startpoint + distance
	
	var endpointTween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	endpointTween.tween_property(self, "position:y", endpoint, 1)
	

func _on_devil_timer_timeout():
	toStart = !toStart
	if toStart:
		var startpointTween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
		startpointTween.tween_property(self, "position:y", startpoint, 1)
	elif !toStart:
		var endpointTween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
		endpointTween.tween_property(self, "position:y", endpoint, 1)
