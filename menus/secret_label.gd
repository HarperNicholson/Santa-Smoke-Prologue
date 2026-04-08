extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	self.modulate.a = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	self.modulate.a = (canecount.canes * 0.0002)
