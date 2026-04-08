extends Node2D

var mobs := [
	preload("res://assets/elf/elf.tscn"),
	preload("res://assets/elf/red_elf.tscn"),
	#preload(),
]

func _unhandled_input(event):
	if event is InputEventMouseButton:
		var m = mobs.pick_random()
		
		var newm = m.instantiate()
		self.add_child(newm)
		print("mob spawned of type " + str(m))
