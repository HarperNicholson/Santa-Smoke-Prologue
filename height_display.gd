extends RichTextLabel

func _ready():
	self.text = "[center]" +  "0M" + "[/center]"


func _process(_delta):
	var heightText : float = ((canecount.player_y - 678)/ 80) * -1
	canecount.m = int(heightText)
	self.text = "[center]" + str(canecount.m) + "M" + "[/center]"
