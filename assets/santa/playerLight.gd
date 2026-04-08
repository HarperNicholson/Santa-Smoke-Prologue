extends Node2D

# Heights (in meters) for maximum and minimum energy levels

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	# Convert player's y position to meters from an arbitrary point (678) and invert the direction
	var m : float = (canecount.player_y - 678) / -80.0
	var interp_factor : float
	
	var max_energy_height
	var min_energy_height
	if m > -700:
		max_energy_height = 6 # Highest energy at 0m
		min_energy_height = 9.5 # Lowest energy at 5m
		
		m = clamp(m, max_energy_height, min_energy_height)
	else:
		max_energy_height = -700 # Highest energy at -550m
		min_energy_height = -900 # Lowest energy at -900m
		
		m = clamp(m, min_energy_height, max_energy_height) # Note: min and max are swapped due to negative values
	
	
	# Calculate the interpolation factor based on m's position between the max and min energy heights
	interp_factor = (m - max_energy_height) / (min_energy_height - max_energy_height)
	
	# Calculate energy for light and shadow using the interpolation factor
	var light_energy : float = max(0.0, 0.6 * (1 - interp_factor))
	var shadow_energy : float = max(0.0, 0.1 * (1 - interp_factor))
	
	# Set the energy levels
	$TextureLight.energy = light_energy
	$Shadow.energy = shadow_energy
