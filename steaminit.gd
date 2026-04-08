extends Node

var steam_id = Steam.getSteamID()

func _ready():
	var init = Steam.steamInit()
	print("Steam init:", init)
	Steam.requestUserStats(steam_id)
