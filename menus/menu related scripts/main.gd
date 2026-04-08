extends Node2D

var reverb_effect_index = 0
var master_bus_index

var spawnTypes := [
	preload("res://assets/santa/player_santa.tscn"),
	preload("res://assets/elf/elf.tscn"),
	preload("res://assets/elf/red_elf.tscn"),
	preload("res://assets/bonusmobs/globetrotter/globetrotter.tscn"),
]

func _ready():
	canecount.resetVars()
	if achievements.is_achieved("GOLDENSANTA") == true:
		canecount.golden_santa = true
	if achievements.is_achieved("SECRET") == true:
		canecount.golden_santa = false
		canecount.secretCharacter = true
	canecount.is_implanted = false
	AudioServer.set_bus_volume_db(1, canecount.audioBus1MaxVolume)
	AudioServer.set_bus_volume_db(2, canecount.audioBus2MaxVolume)
	
	ProjectSettings.set_setting("physics/2d/default_gravity", 980)
	call_deferred("remove_effect")

func goldenSantaCheck():
	if (achievements.is_achieved("ABDUCTION")
	and achievements.is_achieved("DESCENT")
	and achievements.is_achieved("EVIL")
	and achievements.is_achieved("HAHA")
	and achievements.is_achieved("LOSTINSPACE")
	and achievements.is_achieved("MAXCAYNE")
	and achievements.is_achieved("OLDHELL")
	and achievements.is_achieved("REDACTED")
	and achievements.is_achieved("SAYNOTOSMOKING")
	and achievements.is_achieved("TRUEFAN")
	and achievements.is_achieved("WEIGHTLESS")
	and achievements.is_achieved("WHY")
	and achievements.is_achieved("YOUGOTTOOCOLD")
	):
		achievements.unlock_achievement("GOLDENSANTA")

func remove_effect():
	var bus_index = AudioServer.get_bus_index("Master")
	var effect_index = 0
	AudioServer.remove_bus_effect(bus_index, effect_index)

func _on_play_button_down():
	get_tree().call_group("blackOverlay", "fade_in")
	$Timer.start()


func _on_credits_button_down():
	print("ATTEMPTING UNLOCK IF CONDITIONS MET")
	achievements.unlock_achievement("TRUEFAN")
	
	$menu.visible = !$menu.visible
	$cred_text.visible = !$cred_text.visible
	$menu/MenuColliders.collision_layer  = 2
	$cred_text/CreditsColliders.collision_layer  = 1
func _on_back_button_down():
	$menu.visible = !$menu.visible
	$cred_text.visible = !$cred_text.visible
	$menu/MenuColliders.collision_layer  = 1
	$cred_text/CreditsColliders.collision_layer  = 2
func _on_linktree_button_down():
	OS.shell_open("https://linktr.ee/Headlesslezus")


func _on_harpernicholson_button_down():
	OS.shell_open("https://harpernicholson.ca")

func _on_harpernicholson_2_button_down() -> void:
	OS.shell_open("https://www.youtube.com/@harpernicholson1")


func _on_harpernicholson_3_button_down() -> void:
	OS.shell_open("https://p0tterindy.newgrounds.com/")


func _on_notetothorbutton_button_down():
	$menu/notetothor.visible = true
	$menu/notetothorbutton.visible = false


func _on_redacted_pressed():
	achievements.unlock_achievement("REDACTED")
	$"menu/santa icon".hide()
	spawnRandomType()

func spawnRandomType():
	var pickedRandomType = spawnTypes.pick_random()
	var spawnedType = pickedRandomType.instantiate()
	self.add_child(spawnedType)
	spawnedType.position.x = 344
	spawnedType.position.y = 117
	#cool logic for finding out if the picked type is of certain index
	#i did it all by myself!!!!!1!!1!!!1111!
	#if pickedRandomType == spawnTypes[0]:
		#$"menu/santa icon".hide()

func _on_timer_timeout():
	if $menu/skipIntroToggle.button_pressed:
		get_tree().change_scene_to_file("res://snowy.tscn")
	else:
		get_tree().change_scene_to_file("res://menus/intro.tscn")


func _on_instance_culling_area_entered(area):
	area.queue_free()
func _on_instance_culling_body_entered(body):
	body.queue_free()

func _on_golden_santa_timer_timeout():
	goldenSantaCheck()


func _on_play_2_button_down() -> void:
	get_tree().quit()
