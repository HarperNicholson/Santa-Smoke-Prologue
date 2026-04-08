extends Node

func unlock_achievement(id: String):
	if !is_achieved(id):
		var achievement_get_instance = load("res://medalIcons/medalPopups/" + id + ".tscn").instantiate()
		achievement_get_instance.z_index = 1000
		get_tree().get_current_scene().add_child(achievement_get_instance)
		Steam.setAchievement(id)
		Steam.storeStats()

func is_achieved(id: String) -> bool:
	var achieved = Steam.getAchievement(id).get("achieved", false)
	return achieved

func _process(_delta):
	Steam.run_callbacks()
