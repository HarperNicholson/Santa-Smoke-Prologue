extends Node2D


#in future, for platforms with variants, still only create 1 platform, but give a script 
#to set platform variant on ready
var snowyPlatforms := [
	preload("res://assets/platforms/snow/snow_platform_1.tscn"),
	preload("res://assets/platforms/snow/snow_platform_2.tscn"),
	preload("res://assets/platforms/snow/snow_platform_3.tscn"),
	preload("res://assets/platforms/snow/snow_platform_4.tscn"),
	preload("res://assets/platforms/snow/snow_platform_5.tscn"),
	preload("res://assets/platforms/snow/snow_platform_6.tscn"),
]


var mobs := [
	preload("res://assets/elf/elf.tscn"),
	preload("res://assets/elf/red_elf.tscn"),
	preload("res://assets/bonusmobs/globetrotter/globetrotter.tscn"),
	#preload(),
]


var candycane = preload("res://assets/candycane.tscn")
var chimney = preload("res://assets/chimney/chimney.tscn")
var UFO = preload("res://assets/bonusmobs/UFO/UFO.tscn")

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
	ProjectSettings.set_setting("physics/2d/default_gravity", 980)
	canecount.player_highest_y = canecount.player_y
	canecount.canes = 0
	canecount.m = 0
	
	#move up an and index * -unit in V, perhaps increasing array size
	
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
	if canecount.canes >= 500:
			print("UNLOCKING MaxCayneMedal")
			achievements.unlock_achievement("MAXCAYNE")


func check_and_generate_row():
	#calculate the number of rows that should have been generated based on the player's height
	var expected_rows_unclamped = int(abs(canecount.player_y) / 80) + 18  # +18 to keep buffer
	var expected_rows = clampi(expected_rows_unclamped, 0, 1000) #max 1000 rows
	
	#generate rows if the player has moved up
	while canecount.totalRows < expected_rows:
		generate_row(canecount.totalRows)
		canecount.totalRows += 1
		#update to set a new threshold 80 pixels above the current player position

func generate_row(rowIndex):
	var newRow = H.duplicate()
	V.append(newRow)
	hGen(newRow, rowIndex)
	last_generated_row_y = rowIndex * -80  #Update the last generated row's Y position


func mobSpawnCheck(rowIndex):
	var spawnNumber = randi_range(1, 33)
	if spawnNumber == 33:
		var mobType = mobs.pick_random()
		var mob = mobType.instantiate()
		mob.position.x = 640
		mob.position.y = ((rowIndex * unit + unit*10)*(-1)) - 540
		add_child(mob)
		print("MOB SPAWNED! TYPE = " + str(mob))
		var orbnumber = randi_range(1, 100)
		if orbnumber == 33:
			var orbinstance = load("res://assets/bonusmobs/UFO/orb.tscn").instantiate()
			orbinstance.position.y = $"../SantaPlayer".position.y - 120
			self.add_child(orbinstance)

func UFOCheck(rowIndex):
	if canecount.m > 500: #level at which to start spawning UFOs!!!!
		var UFOspawn = randi_range(1, 66) #range chance
		if UFOspawn == 33:
			#EITHER -1280*2 OR 1280*3
			var UFOInstance = UFO.instantiate()
			#flipacoin and ensure accessible    
			UFOInstance.position.x = (1280*5 * randi_range(0, 1)) - 1280*2
			UFOInstance.position.y = ((canecount.m * unit)*(-1)) - unit*(randi_range(-8, 8))
			add_child(UFOInstance)
			print("UFO SPAWNED AT ROW INDEX " + str(rowIndex))

func chimneyCheck(rowIndex):
	if canecount.canes >= 100 and canecount.m < 620: #level at which to start spawning chimneys, cuts off at 666 which is space
		var chimneySpawnNumber = randi_range(1, 50) #range chance
		if chimneySpawnNumber == 33:
			
			var chimneyinstance = chimney.instantiate()
			#flipacoin and ensure accessible    
			chimneyinstance.position.x = 1280 * randi_range(0, 1)
			chimneyinstance.position.y = ((rowIndex * unit + unit*10)*(-1))
			chimneyinstance.targetScene = "res://assets/chimney/chimneyLevel.tscn"
			add_child(chimneyinstance)
			print("CHIMNEY SPAWNED AT ROW INDEX " + str(rowIndex))

func hGen(row, rowIndex):
	#numbers are drawn between 1 and unlikeliness, and if landing on 1 then it is a spawn
	#indexes behind spawn point will be set to 1 according to platform size 
	#according to the length of the platform trying to spawn (1 - 6)
	# H[0] tells you the value of the first number in H, H[15] tells you the value of the last numbers
	
	#this runs for each position in H, 0 - 15
	for currentIndex in range(H.size()):
		var magicNumber = randi_range(1, unlikeliness)
		if magicNumber == 1:
			var platformSize : int = determinePlatformSize()
			if canSpawnPlatform(row, currentIndex, platformSize, rowIndex):
				spawnPlatform(platformSize, currentIndex, rowIndex)
				
				#update H array for the current row
				for i in range(currentIndex, min(currentIndex + platformSize, H.size())):
					row[i] = 1  # mark occupied
				
				# update V array
				V[rowIndex] = row.duplicate()
			
	
	
	#CANESSS
	for currentIndex in range(row.size()):
		if row[currentIndex] == 0:  #if the space is unoccupied
			var candycaneChance = randi_range(1, 33) 
			if candycaneChance <= 1:  #  range for spawning candy canes
				spawnCandycane(currentIndex, rowIndex)
				row[currentIndex] = 2  #mark occupied by candy cane
	V[rowIndex] = row.duplicate()
	
	mobSpawnCheck(rowIndex)
	chimneyCheck(rowIndex)
	UFOCheck(rowIndex)

func determinePlatformSize():
	var platformPick = randi_range (1, 21)
	var platformSize : int
	if (platformPick <= 6):
		platformSize = 1
	elif (platformPick >= 7 && platformPick <= 11):
		platformSize = 2
	elif (platformPick >= 12 && platformPick <= 15):
		platformSize = 3
	elif (platformPick >= 16 && platformPick <= 18):
		platformSize = 4
	elif (platformPick == 19 || platformPick == 20):
		platformSize = 5
	elif (platformPick >= 21):
		platformSize = 6
	return platformSize

func canSpawnPlatform(row, currentIndex, platformSize, rowIndex):
	# Horizontal Check
	for i in range(max(0, currentIndex - 2), min(currentIndex + platformSize + 2, row.size())):
		if row[i] == 1:
			return false  # not enough h space
	
	# Vertical Check (for previous 2 rows)
	for i in range(max(0, rowIndex - 2), rowIndex):
		for j in range(currentIndex, min(currentIndex + platformSize, V[i].size())):
			if V[i][j] == 1:
				return false  # Nnot enough vertical space
	
	return true  # Enough space 

func spawnPlatform(platformSize, currentIndex, rowIndex):
	
	
	
	#grab object from snowyPlatforms array at index of platformSize - 1, instance and add child
	var platformScene = snowyPlatforms[platformSize - 1]
	var platformInstance = platformScene.instantiate()
	platformInstance.position.x += currentIndex * unit
	platformInstance.position.y = ((rowIndex * unit)*(-1)) + 540
	add_child(platformInstance)

func spawnCandycane(currentIndex, rowIndex):
	var candycaneInstance = candycane.instantiate()
	candycaneInstance.position.x += currentIndex * unit
	candycaneInstance.position.y = ((rowIndex * unit)*(-1)) + 540
	add_child(candycaneInstance)
