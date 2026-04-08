extends StaticBody2D

@export var elfIsSacrificialOne : bool = false

func _ready():
	var elfType = randi_range(1,2)
	
	var pickedElfTypeForInstance
	
	if elfType == 1:
		pickedElfTypeForInstance = load("res://assets/elf/elf.tscn")
	elif elfType == 2:
		pickedElfTypeForInstance = load("res://assets/elf/red_elf.tscn")
	
	var elfInstance = pickedElfTypeForInstance.instantiate()
	
	
	if elfIsSacrificialOne:
		elfInstance.position.x = 0
		elfInstance.position.y = 453.031
		elfInstance.scale.x = 0.483
		elfInstance.scale.y = 0.483
		elfInstance.z_index = -1
		
	else:
		elfInstance.isElfMuted = true
		elfInstance.z_index = -5
		
		elfInstance.scale.x = 0.082
		elfInstance.scale.y = 0.082
		
		elfInstance.position.x = 114
		elfInstance.position.y = 278
	
	elfInstance.set_collision_layer_value(1, 0)
	elfInstance.set_collision_mask_value(1, 0)
	elfInstance.set_collision_layer_value(9, 1)
	elfInstance.set_collision_mask_value(9, 1)
	
	self.add_child(elfInstance)
