extends Node2D


var spritesDylanLog : Array = [
	preload("res://assets/chimney/assets/dylanslogs/sprites_dylanslog/dylanslog1.png"),
	preload("res://assets/chimney/assets/dylanslogs/sprites_dylanslog/dylanslog2.png"),
	preload("res://assets/chimney/assets/dylanslogs/sprites_dylanslog/dylanslog3.png"),
	preload("res://assets/chimney/assets/dylanslogs/sprites_dylanslog/dylanslog4.png"),
	preload("res://assets/chimney/assets/dylanslogs/sprites_dylanslog/dylanslog5.png"),
	preload("res://assets/chimney/assets/dylanslogs/sprites_dylanslog/dylanslog6.png"),
	preload("res://assets/chimney/assets/dylanslogs/sprites_dylanslog/dylanslog7.png"),
	preload("res://assets/chimney/assets/dylanslogs/sprites_dylanslog/dylanslog8.png"),
	preload("res://assets/chimney/assets/dylanslogs/sprites_dylanslog/dylanslog9.png"),
]

var dylansLog = preload("res://assets/chimney/assets/dylanslogs/dylanslog.tscn")

var aspectY : Array = [1, 2, 3, 4, 5, 6, 7, 8, 9] #may be not needed

var aspectX : Array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]

var H : Array = []
var V : Array = []


#value of 32 makes 1 platform spawn every 2 rows on average
#value of 16 makes 1 platform spawn per row on average, etc
#value is currently low for frequent spawning, for testing reasons
var unlikeliness : int = 8

#to multiply aspectX index [0 - 15] by to get horizontal position on screen
var unit : int = 80

var last_generated_row_y = 0

func _ready():
	canecount.player_lowest_y = canecount.player_y
	
	#fill H with zeros to begin with
	for grid in aspectX:
		H.append(0)
	#draw one row in V
	
	for i in range(0, canecount.totalRows): #PRE generate rows equal to total rows
		var newRow = H.duplicate()
		V.append(newRow)
		hGen(newRow, i)

func _process(_delta):
	check_and_generate_row()
	if abs(canecount.player_y) / 80 <= -666:
		canecount.allowUnstuck = false


func check_and_generate_row():
	# Calculate the number of rows that should have been generated based on the player's height
	var expected_rows = int(abs(canecount.player_y) / 80) + 18  # +18 to keep buffer

	# Generate rows if the player has moved up and the rowIndex is less than 666
	while canecount.totalRows < expected_rows and canecount.totalRows <= 679:
		generate_row(canecount.totalRows)
		canecount.totalRows += 1

func generate_row(rowIndex):
	var newRow = H.duplicate()
	V.append(newRow)
	hGen(newRow, rowIndex)
	last_generated_row_y = rowIndex * -unit  # Update the last generated row's Y position

func hGen(row, rowIndex):
	# Skip platform generation for the first 6 rows
	
	#set to 12
	if rowIndex < 12:
		return
	
	
	for currentIndex in range(H.size()):
		var magicNumber = randi_range(1, unlikeliness)
		if magicNumber == 1:
			var platformSize : int = 3  # Example size, adjust as necessary
			if canSpawnPlatform(row, currentIndex, platformSize, rowIndex):
				spawnPlatform(platformSize, currentIndex, rowIndex)
				
				# Update the H array for the current row to mark as occupied
				for i in range(currentIndex, min(currentIndex + platformSize, H.size())):
					row[i] = 1
				
				# Update the V array
				V[rowIndex] = row.duplicate()
			
			
			
		
		
		
		
	
	V[rowIndex] = row.duplicate()
	print(row)

func canSpawnPlatform(row, currentIndex, platformSize, rowIndex):
	# Disallow spawning at the first and last horizontal index
	if currentIndex == 0 or currentIndex >= aspectX.size() - 1:
		return false

	# Adjust the range to ensure platforms don't spawn at the last index
	if currentIndex + platformSize > aspectX.size() - 1:
		return false

	# Horizontal Check
	for i in range(max(1, currentIndex - 2), min(currentIndex + platformSize + 2, row.size() - 1)):
		if row[i] == 1:
			return false  # Not enough horizontal space

	# Vertical Check (for previous 2 rows)
	for i in range(max(0, rowIndex - 2), rowIndex):
		for j in range(max(1, currentIndex), min(currentIndex + platformSize, V[i].size() - 1)):
			if V[i][j] == 1:
				return false  # Not enough vertical space

	return true  # Enough space to spawn

func spawnPlatform(_platformSize, currentIndex, rowIndex):
	var logInstance = dylansLog.instantiate()
	logInstance.position.x = currentIndex * unit + 33
	# Updated y position calculation: Directly use rowIndex * unit, adjust if necessary for starting position
	logInstance.position.y = rowIndex * unit  # Adjust starting position if needed
	logInstance.get_node("Sprite2D").texture = spritesDylanLog.pick_random()
	add_child(logInstance)
