extends RichTextLabel  # Adjust for your specific node type if necessary

var start_scale = Vector2(0.65, 0.65)
var end_scale = Vector2(0.6, 0.6)
var tween_duration = 0.5  # Duration in seconds
var tweening_to_start_scale = true

var a := "[center]"
var b := "[/center]"

var sayings := [
"MY    BACK    HURTS",
"YOU    CAN'T    DO    THAT    FOREVER!",
"THERE'S     BOUND    TO    BE    AN    END!",
"WORKS    ON    STEAM    DECK!",
"WORKS   WITH   GAMEPAD!",
"RESPEC",
"ALSO    TRY    MINECRAFT!",
"ALSO    TRY    SUPER    MEAT    BOY!",
"ALSO    TRY    GISH!",
"ALSO    WATCH    ELF!",
"MESHUGGAH",
"SCARY    VOICE:    RESIDENT....    EVIL....     FOUR....",
"THE    ESCHATON    IS    NEAR",
"MADE    WITH    BLENDER    AND    GODOT",
"CHECK    OUT    THE    SANTA   [REDACTED]    ITCH.IO    PAGE",
"KRAMPUS    IS    SANTA'S    STEP    BROTHER",
"HELP    ME!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!",
"GREASE    UP",
"GREASE    MONKEY!    YEAH?",
"SLEEPYTIME",
"ASYMMETRICAL    PHYSIQUE    OF    DISBELIEF",
"THE    SKY    IS    FALLING!",
"WHERE    WILL    HE    TROT    NEXT?",
"secret text",
"I    -    THIS    FRACTAL    ILLUSION",
"IT'S    PALLID",
"GO    TO    HELL!   [AND    FIGHT    YOUR    WAY    BACK]",
"DOWN    THROUGH    THE    CHIMNEY",
"WHAT    LIES    AT    THE    BOTTOM?",
"WHAT    WAITS    AT    THE    TOP?",
"IN    DREAMS    IT    SPEAKS    TO    ME    OF    THE    TRUTH    THAT    MEANS    REALITY",
"NOT   TO    BE   CONFUSED    WITH    JACK,    PETE,   OR    DENNIS",
"NOT   TO    BE   CONFUSED    WITH    SANTA    SMOKE",
"NEVER    FINISHED",
"NEXT    GAME:    DRUG    RUNNER",
"SANTA    GETS    IMPLANTS!",
"THERE IS NO GAME",
"FOSS",
"DOWNLOAD FOR FREE ON GITHUB",
"OPEN SOURCE",
"THANK YOU GODOT",
]

func _ready():
	pickText()
	tween_to_scale(start_scale)

func pickText():
	var pickedText = sayings.pick_random()
	self.text = a + pickedText + b

func tween_to_scale(target_scale):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", target_scale, tween_duration)
	$tweentime.start()

func _on_tweentime_timeout():
	tweening_to_start_scale = not tweening_to_start_scale
	var next_scale = start_scale if tweening_to_start_scale else end_scale
	tween_to_scale(next_scale)
	$tweentime.start()
