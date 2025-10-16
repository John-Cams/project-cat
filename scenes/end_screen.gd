extends Node

var input = false

func _ready() -> void:
	var ehScore = 0
	$Addtimer.wait_time = float(1)/abs((float(Global.score))/float(1000))
	if Global.score > 0:
		@warning_ignore("integer_division")
		for i in Global.score/1000:
			ehScore += 1000 
			await $Addtimer.timeout
			$Score.text = ("Score: " + str(ehScore))
	elif Global.score < 0:
		@warning_ignore("integer_division")
		for i in (Global.score*-1)/1000:
			ehScore -= 1000 
			await $Addtimer.timeout
			$Score.text = ("Score: " + str(ehScore))
	else:
		$Score.text = ("Score: 0")
	var grade = ""
	if Global.score == Global.maxScore:
		grade = "P"
	elif Global.score > Global.maxScore*0.95:
		grade = "S" 
	elif Global.score > Global.maxScore*0.9:
		grade = "A"
	elif Global.score > Global.maxScore*0.8:
		grade = "B"
	elif Global.score > Global.maxScore*0.7:
		grade = "C"
	elif Global.score > Global.maxScore*0.6:
		grade = "D"
	elif Global.score == 0:
		grade = "F"
	else:
		grade = "Z"
	$Grade.text = grade
	$Grade.visible = true
	print(Global.score)
		
	input = true
	
func _process(_2delta: float) -> void:
	if input:
		for i in ["redHeart","yellowCircle","greenDiamond","blueTriangle"]:
			if Input.is_action_just_pressed(i):
				$Button.emit_signal("pressed")


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	Global.currentBar = 0
	Global.score = 0
	Global.notesOnScreen = []
	Global.notes = []
	Global.noteLocations = []
	Global.noteInputs = []
	Global.noteCrit = []
	Global.noteComplete = []
