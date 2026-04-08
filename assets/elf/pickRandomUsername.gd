extends Label



var presetNames : Array = [        #no flairs
	"dylant12",
	"harrypotterindy",
	"Headless_Lezus",
	"bigfoot",
	"Look behind you.",
	"Turn off the computer, you're in danger.",
	"Check your closet.",
	"It's under the bed.",
	"matrix",
	"CORRUPT",
]




var preFlairs : Array = [
	"randomNumber_flair",
	"xX",
	"its",
	"69",
	"420",
	"lil",
	"big",
	"gay",
	"1234",
	"SP00KY",
	"festive",
	"the",
	"smart",
	"super",
	"obese",
	"violent",
	"magic",
	"stoned",
	"smoking",
	"addicted",
	"tiny",
	"crack",
	"gas",
	"gassy",
	"snuggly",
	"speeding",
	"speedy",
	"screaming",
	"obese",
	"la",
	"sneaky",
	"sacrificial",
	"hot",
	"sensual",
	"evil",
	"dumb",
	"consenting",
	"rolling",
	"cheating",
	"pink",
	"white",
	"black",
	"green",
	"orange",
	"red",
	"blu",
	"yellow",
	"googley_eyed",
	"blanking",
	"saggy",
	"illegal",
	"pooping",
	"poopy",
	"peeing",
	"wet",
	"rotten",
	"gooey",
	"burning",
	"sleepy",
	"chicken",
	"roaming",
	"lost",
	"ripped",
	"torn",
	"inner",
	"outer",
	"nuclear",
	"bursting",
	"tormented",
	"trapped",
	"conscious",
	"sentient",
	"poor",
	"insane",
	"conceited",
	"tweeking",
	"blue-collar",
	"damned",
	"your",
	"inflamed",
	"magic",
	"veiled",
	"punctured",
	"nailed",
	"skinned",
	"full",
	"rare",
	"solid",
	"beefy",
	"leaking",
	"reeking",
	"good",
]

var proceduralNames : Array = [
	"andrew",
	"puppy",
	"xbox",
	"meatboy",
	"angryelf",
	"elf",
	"skibidi",
	"albert",
	"dog",
	"fatman",
	"dog",
	"hippie",
	"hippy",
	"cheater",
	"moron",
	"ape",
	"addict",
	"monkey",
	"whale",
	"cucaracha",
	"roach",
	"hooker",
	"prostitute",
	"bum",
	"bellend",
	"james",
	"samuel",
	"arthur",
	"snowbell",
	"inky",
	"screamer",
	"puker",
	"biter",
	"spewer",
	"acrobat",
	"twink",
	"adult",
	"devil",
	"alien",
	"buzzword",
	"plank",
	"blank",
	"globetrotter",
	"goo",
	"gish",
	"tar",
	"crap",
	"head",
	"simian",
	"sapien",
	"gorilla",
	"orca",
	"reality",
	"tyrant",
	"bubblebath",
	"swamp_gas",
	"reticuli",
	"colon",
	"hymen",
	"nailbed",
	"underwear",
	"diaper",
	"pit",
	"lazarus",
	"boil",
	"cyst",
	"soul",
	"slave",
	"AI",
	"bumpkin",
	"yokel",
	"buzzard",
	"tweeker",
	"effluencer",
	"truth",
	"child",
	"baby",
	"warhead",
	"orangutan",
	"bonobo",
	"dogshxt",
]


var postFlairs : Array = [
	"randomNumber_flair",
	"birthyear_flair",
	"xX_flair",
	"Xx",
	"69",
	"420",
	"1234",
	"NG",
	"DoesMinecraft",
	"43xx",
	"flu",
	"the_rat",
	"drummer",
	"kisser",
	"killer",
	"fxcker",
	"shxtter",
	"beater",
	"sandwich",
	"stealer",
	"maker",
	"flinger",
	"chucker",
	"sniffer",
	"eater",
	"cooker",
	"roaster",
	"sighting",
	"s",
	"XL",
	"playz",
]


var simplePostFlairs : Array = [
	"randomNumber_flair",
	"birthyear_flair",
	"xX_flair",
	"Xx",
	"69",
	"420",
	"1234",
	"NG",
	"DoesMinecraft",
	"43xx",
	"flu",
	"the_rat",
]

var censoredPost : Array = [
	"randomNumber_flair",
	"birthyear_flair",
	"xX_flair",
	"420",
	"1234",
	"DoesMinecraft",
	"flu",
	"shxtter",
	"stealer",
	"maker",
	"flinger",
	"chucker",
	"eater",
	"stealer",
	"maker",
	"flinger",
	"chucker",
	"eater",
]

var wrapperFlairs : Array = [
	"normal",
	"normal",
	"normal",
	"normal",
	"normal",
	"allcaps_flair",
	"firstLettterCapital_flair",
	"firstLettterCapital_flair",
	"firstLettterCapital_flair",
]


var randomName: String = ""
var preFlair: String = ""
var preFlair2: String = ""
var postFlair: String = ""
var space1 = ""
var space2 = ""
var space3 = ""

var hasPreFlair : bool
var hasPreFlair2 : bool
var hasPostFlair : bool
var hasspace1 : bool
var hasspace2 : bool
var hasspace3 : bool
func _ready():
	createName()


func createName():
	var nameType = randi_range(1, 100)  #the smaller the second number, the greater chance of a preset name
	
	if nameType != 1:  # use a generated name
		randomName = proceduralNames.pick_random()
		
		hasPreFlair = randi_range(0,1)
		hasPreFlair2 = randi_range(0,1)
		hasPostFlair = randi_range(0,100) > 80
		hasspace1 = randi_range(0,1)
		hasspace2 = randi_range(0,1)
		hasspace3 = randi_range(0,1)
		
		if hasPreFlair:
			preFlair = preFlairs.pick_random()
		if hasPreFlair2:
			preFlair2 = preFlairs.pick_random()
		if hasPostFlair:
			postFlair = postFlairs.pick_random()
		if hasspace1:
			space1 = "_"
		if hasspace2:
			space2 = "_"
		if hasspace3:
			space3 = "_"
		
	elif nameType == 1:  # use a preset name
		randomName = presetNames.pick_random()
		
	
	if get_parent().name == "SantaPlayer":
		randomName = "santa"
		canecount.itsSanta = true
	
	#grammar fix
	if randomName == "screamer" or randomName == "puker"or randomName == "biter"or randomName == "spewer":
		postFlair = simplePostFlairs.pick_random()
	#morality fix
	if randomName == "child" or randomName == "baby":
		postFlair = censoredPost.pick_random()
		if preFlair == "69" or preFlair == "consenting" or preFlair == "hot" or preFlair == "sensual" or preFlair == "wet" or preFlair == "pooping" or preFlair == "peeing" or preFlair == "consenting" or preFlair == "skinned" or preFlair == "poopy" or preFlair == "torn" or preFlair == "ripped" or preFlair == "nailed" or preFlair == "punctured" or preFlair == "trapped" or preFlair == "gay" or preFlair == "leaking" or preFlair == "beefy":
			preFlair = ""
			hasPreFlair = false
		if preFlair2 == "69" or preFlair2 == "consenting" or preFlair2 == "hot" or preFlair2 == "sensual" or preFlair2 == "wet" or preFlair2 == "pooping" or preFlair2 == "peeing" or preFlair2 == "consenting" or preFlair2 == "skinned" or preFlair2 == "poopy" or preFlair2 == "torn" or preFlair2 == "ripped" or preFlair2 == "nailed" or preFlair2 == "punctured" or preFlair2 == "trapped" or preFlair2 == "gay" or preFlair2 == "leaking" or preFlair2 == "beefy":
			preFlair2 = ""
			hasPreFlair2 = false
		
	
	var modifiedFlairs = checkFlairType(preFlair, preFlair2, postFlair)
	preFlair = modifiedFlairs[0]
	preFlair2 = modifiedFlairs[1]
	postFlair = modifiedFlairs[2]
	
	if preFlair == "xX_flair" or postFlair == "xX_flair": 
		preFlair = "xX_"
		postFlair = "_Xx"
		hasPreFlair = false
		hasPostFlair = false
	elif preFlair2 == "xX_flair":
		preFlair = "xX_"
		postFlair = "_Xx"
		preFlair2 = ""
		hasPreFlair2 = false
		hasPreFlair = false
		hasPostFlair = false
	
	
	#conditional to upper
	if postFlair == "NG" or postFlair == "DoesMinecraft":
		firstLetterCapital()
	
	var wrapperFlairType = wrapperFlairs.pick_random()
	
	if wrapperFlairType == "firstLettterCapital_flair":
		firstLetterCapital()
	
	if postFlair == "s" or postFlair == "S":
		space3 = ""
		postFlair = "s"
	
	var username : String = preFlair + space1 + preFlair2 + space2 + randomName + space3 + postFlair
	
	if wrapperFlairType == "allcaps_flair":
		username = username.to_upper()
	
	if get_parent().name == "SantaPlayer" and canecount.itsSanta == true and canecount.hasAppliedSantaUser == true:
		username = canecount.santaUsername
	elif get_parent().name == "SantaPlayer" and canecount.itsSanta == true and canecount.hasAppliedSantaUser == false:
		canecount.santaUsername = username
		canecount.hasAppliedSantaUser = true
	
	self.text = username
	

var frame_counter = 0

var fontCharacters: Array = [
	"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p",
	"q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E",
	"F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T",
	"U", "V", "W", "X", "Y", "Z", "1", "2", "3", "4", "5", "6", "7", "8", "9",
	"0", "!", "?", "+", "-", "*", "/", "=", ".", ",", ":", ";", "'", "(", ")",
]

func _physics_process(_delta):
	
	frame_counter += 1
	
	if frame_counter % 2 == 1:
		if randomName == "matrix":
			hasPreFlair2 = false
			hasPreFlair = false
			hasPostFlair = false
			var matrixName = ""  # Start with an empty string
			for i in range(8):  # Assuming you want to replace 8 characters
				matrixName += str(randi_range(0, 9))  # Append a random number as a string
			self.text = matrixName
	
	if frame_counter % 12 == 1:
		if randomName == "CORRUPT":
			hasPreFlair2 = false
			hasPreFlair = false
			hasPostFlair = false
			var corruptName = ""  # Start with an empty string
			for i in range(12):  # Assuming you want to replace 8 characters
				corruptName += fontCharacters.pick_random()  # Append a random number as a string
			self.text = corruptName

func checkFlairType(flair1, flair2, flair3) -> Array:
	var flairs = [flair1, flair2, flair3]
	var modifiedFlairs = []
	
	for flair in flairs:
		if flair == "randomNumber_flair":
			modifiedFlairs.append(str(randi_range(0, 999)))
		elif flair == "birthyear_flair":
			modifiedFlairs.append(str(randi_range(2000, 2014)))
		else:
			modifiedFlairs.append(flair)
	
	return modifiedFlairs

func firstLetterCapital():
	randomName = randomName[0].to_upper() + randomName.substr(1,-1) ##nothing fuckingwokrs  NVM OBVIOUSLY MAKE IT EQUAL TO THE RESULT
	if hasPreFlair2:
			preFlair2 = preFlair2[0].to_upper() + preFlair2.substr(1,-1) ##nothing fuckingwokrs  NVM OBVIOUSLY MAKE IT EQUAL TO THE RESULT
	if hasPreFlair:
			preFlair = preFlair[0].to_upper() + preFlair.substr(1,-1)
	if hasPostFlair:
			postFlair = postFlair[0].to_upper() + postFlair.substr(1,-1)
