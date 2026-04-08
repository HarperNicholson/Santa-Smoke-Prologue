extends Node

func _process(_delta):
	if canecount.is_implanted == true:
		achievements.unlock_achievement("ABDUCTION")
