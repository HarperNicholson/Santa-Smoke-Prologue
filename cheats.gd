extends Node

# Define cheat codes and their corresponding actions in a dictionary
var cheat_codes = {
	"secret_code": ["ui_up", "ui_up", "ui_down", "ui_down", "ui_left", "ui_right", "ui_left", "ui_right", "a", "b", "f", "u", "c", "k"],
	"hell_code": ["c", "d", "h", "e", "l", "l"],
	"moon_code": ["c", "d", "m", "o", "o", "n"],
	"chimney_code": ["c", "d", "c", "h"],
	"space_code": ["c", "d", "s", "p", "a", "c", "e"],
	"ufo_code": ["s", "p", "u", "f", "o"],
	"gt_code": ["s", "p", "g", "t"],
	"elf_code": ["s", "p", "e"],
	"orb_code": ["s", "p", "o"]
}

var current_input_sequence = []

func _input(event):
	if event is InputEventKey and event.pressed:
		var action = get_action_for_key(event.keycode)
		if action != "":
			current_input_sequence.append(action)
			check_sequence()

func get_action_for_key(keycode):
	# Map each keycode to an action
	var action_map = {
		KEY_UP: "ui_up",
		KEY_DOWN: "ui_down",
		KEY_LEFT: "ui_left",
		KEY_RIGHT: "ui_right",
		KEY_A: "a",
		KEY_B: "b",
		KEY_C: "c",
		KEY_D: "d",
		KEY_E: "e",
		KEY_F: "f",
		KEY_G: "g",
		KEY_H: "h",
		KEY_I: "i",
		KEY_J: "j",
		KEY_K: "k",
		KEY_L: "l",
		KEY_M: "m",
		KEY_N: "n",
		KEY_O: "o",
		KEY_P: "p",
		KEY_Q: "q",
		KEY_R: "r",
		KEY_S: "s",
		KEY_T: "t",
		KEY_U: "u",
		KEY_V: "v",
		KEY_W: "w",
		KEY_X: "x",
		KEY_Y: "y",
		KEY_Z: "z",
		# Add other mappings here
	}
	return action_map.get(keycode, "")

func check_sequence():
	var matched_code = ""
	# Iterate over the keys of the dictionary
	for code in cheat_codes.keys():
		var sequence = cheat_codes[code]  # Access the sequence by its code (key)
		if current_input_sequence.size() <= sequence.size() and current_input_sequence == sequence.slice(0, current_input_sequence.size()):
			if current_input_sequence.size() == sequence.size():
				matched_code = code  # Found a match
				break  # Correctly exits the for loop
	if matched_code != "":
		execute_action(matched_code)
		current_input_sequence = []  # Reset after executing an action
	else:
		# Additional logic to handle partial matches correctly
		var any_possible_match = false
		for code in cheat_codes.keys():
			var sequence = cheat_codes[code]
			if sequence.size() > current_input_sequence.size() and sequence.slice(0, current_input_sequence.size()) == current_input_sequence:
				any_possible_match = true
				break
		if not any_possible_match:
			current_input_sequence = []  # Reset if no possible matches




func execute_action(code):
	match code:
		"secret_code":
			canecount.secretCharacter = true
			achievements.unlock_achievement("SECRET")
		"hell_code":
			change_level_to_hell()
		"moon_code":
			change_level_to_moon()
		"space_code":
			if get_tree().get_current_scene().name == "Testing":
				teleport_player_to_space()
		"ufo_code":
			if get_tree().get_current_scene().name == "Testing":
				spawn_ufo()
		"gt_code":
			spawn_gt()
		"elf_code":
			spawn_elf()
		"orb_code":
			spawn_orb()
		"chimney_code":
			get_tree().change_scene_to_file("res://assets/chimney/chimneyLevel.tscn")
	current_input_sequence = []  # Reset after executing action

func change_level_to_hell():
	get_tree().change_scene_to_file("res://assets/background/newHell.tscn")

func change_level_to_moon():
	get_tree().change_scene_to_file("res://moon.tscn")

func teleport_player_to_space():
	print("space code")
	get_tree().get_current_scene().get_child(0).position.y = 900*-80

func spawn_ufo():
	print("ufo code")
	var UFOInstance = load("res://assets/bonusmobs/UFO/UFO.tscn").instantiate()
	UFOInstance.position.x = (1280*5 * randi_range(0, 1)) - 1280*2
	UFOInstance.position.y = get_tree().get_current_scene().get_child(0).position.y
	get_tree().get_current_scene().add_child(UFOInstance)

func spawn_gt():
	print("gt code")
	var gtinst = load("res://assets/bonusmobs/globetrotter/globetrotter.tscn").instantiate()
	gtinst.position.x = get_tree().get_current_scene().get_child(0).position.x
	gtinst.position.y = get_tree().get_current_scene().get_child(0).position.y - 60
	get_tree().get_current_scene().add_child(gtinst)

func spawn_elf():
	print("elf code")
	var elfType = randi_range(0,1)
	var elf
	if elfType == 0:
		elf = load("res://assets/elf/elf.tscn")
	elif elfType == 1:
		elf = load("res://assets/elf/red_elf.tscn")
	var elfinst = elf.instantiate()
	elfinst.position.x = get_tree().get_current_scene().get_child(0).position.x
	elfinst.position.y = get_tree().get_current_scene().get_child(0).position.y - 60
	get_tree().get_current_scene().add_child(elfinst)

func spawn_orb():
	print("orb code")
	var orbinstance = load("res://assets/bonusmobs/UFO/orb.tscn").instantiate()
	orbinstance.position.y = get_tree().get_current_scene().get_child(0).position.y - 120
	get_tree().get_current_scene().add_child(orbinstance)
