extends Node

signal hit(score: int)

##The two sprites used to indicate Color mode and Shape mode
var types = [preload("res://assets//Color.png"),preload("res://assets//Shape.png")]
##The name of the inputs
var inputs = ["redHeart","yellowCircle","greenDiamond","blueTriangle"]
##The scene of the note
const NOTE = preload("res://scenes/note.tscn")
##Colors to be used later
@export var colors: PackedColorArray
##Colors for reaction
@export var reaction: PackedColorArray
##List of current shapes
var shapes = []
## Boolean that turns on when the scene is ready
var isReady = false
##The mimimum x value of the bar
var minX = 400
##The maximum x value of the bar
var maxX = 1500
##The difference between the max and min
var distanceBase = 0
##The distance between each note
var distance = 0
##Turns the inputs on or off
var inputOn = false
##The index of the note in Global.notes
var currentNote = 0

#Look at matrix for every line there will be four numbers 1-0 if number is 1 spawn at that location else don't 

func _ready():
	isReady = true
	minX = get_node("Staff/PerfectArea/Perfect").global_position.x
	distanceBase = ((maxX-100)-(minX+100))
	$Spawnstart.wait_time = ((60.0/Global.BPM)*8.0)

func _process(_delta: float) -> void:
	#Only runs if inputOn is on
	if !inputOn:
		return
	
	var doContinue = false
	
	##Indexes of important notes
	var inputLocations = []
	##Locations of important notes
	var noteLocations = []
	##Only runs if the input is one in Global.noteiNputs
	for i in Global.noteInputs.size():
		if(Input.is_action_just_pressed(inputs[Global.noteInputs[i]])):
			doContinue = true
			inputLocations.append(i)
			noteLocations.append(Global.noteLocations[i])
	if !doContinue:
		return
	
	##The place where index of the pressed note
	var location = -1
	##The sensor where the note was pressed
	var score = -1
	
	##Only runs if the size of inputLocations is 0
	if inputLocations.size()==1:
		location = inputLocations[0]
		score = Global.noteLocations[inputLocations[0]]
	elif inputLocations.size() == 0:
		changeScore(-1000)
		$Cat.texture = Global.catTextures[1]
		return
	else:
		location = Global.noteLocations.find(noteLocations.max())
		score = noteLocations.max()
	
	##Only runs if the location of the pressed note is actually in a sensor
	if score < 1:
		changeScore(-1000)
		$Cat.texture = Global.catTextures[1]
		return
	
	##Only runs if the note is not already completed
	if Global.noteComplete[location]:
		return
		
	#Only runs if the note is not a blank note
	if Global.notesOnScreen[location].get_child_count() == 0:
		return
	
	#Sets the note's completeness to true
	Global.noteComplete[location] = true
	var crit = 2 if Global.noteCrit[location] else 1
	
	#Emits a score signal
	hit.emit(score)
	$Cat.texture = Global.catTextures[0]
	
	#Makes the note invisible and changes the score depending on the noets location
	Global.notesOnScreen[location].get_node("NoteAS").visible = false 
	changeScore((score/2)*1000*crit)
	var prevColor = $Staff/CoolColors.color
	$Staff/CoolColors.color = reaction[((score-1)/2)]
	await $Timer.timeout
	$Staff/CoolColors.color = prevColor

##Changes the displayed score and the actuall score
func changeScore(add: int):
	Global.score += add
	$Score.text = "Score: " + str(Global.score)

##Creates a random pattern for the user to press
func shuffle():
	
	var isShape = false
	
	#print(Global.allNotes.size())
	if Global.currentBar == Global.allNotes.size():
		get_tree().change_scene_to_file("res://scenes/endScreen.tscn")
		print("Hai")
		return
		#Global.currentBar = -1
	Global.notes = Global.allNotes[Global.currentBar]
	print(Global.currentBar)
	print(Global.notes)
	Global.currentBar += 1
	
	shapes = []
	
	var distanceDiv = 0
	for i in Global.notes:
		if(i=="1"):
			Global.noteLocations.append(-1)
			Global.noteInputs.append(randi_range(0,3))
			Global.noteCrit.append(false)
			Global.noteComplete.append(false)
			distanceDiv += 1
		elif(i=="2"):
			Global.noteLocations.append(-1)
			Global.noteInputs.append(randi_range(0,3))
			Global.noteCrit.append(true)
			Global.noteComplete.append(false)
			distanceDiv += 1
		else:
			Global.noteLocations.append(0)
			Global.noteInputs.append(-1)
			Global.noteCrit.append(false)
			Global.noteComplete.append(false)
			distanceDiv += 1
	
	distance = distanceBase/distanceDiv
	print(Global.noteCrit)
	
	isShape = (randi_range(0,1)==0)
	$Indicator.texture = types[int(isShape)]
	$Staff/CoolColors.color = colors[int(isShape)]
	
	for i in distanceDiv:
		var crit = (Global.noteCrit[currentNote])
		if(Global.notes[i]!="0"):
			if isShape:
				shapes.append(20+Global.noteInputs[currentNote] if crit else Global.noteInputs[currentNote]+4*randi_range(0,3))
			else:
				shapes.append(16+Global.noteInputs[currentNote] if crit else Global.noteInputs[currentNote]*4+randi_range(0,3))
		else:
			shapes.append(-1) 
		currentNote += 1
	
	spawnShapes(shapes)

func spawnShapes(shapeList):
	
	$Timer.wait_time = (((float(Global.BPM)/60)*4.0/shapeList.size()))
	
	for i in shapeList.size():
		await $Timer.timeout
		var note = shapeList[i]
		if (note!=-1):
			var new = NOTE.instantiate()
			new.position = Vector2(minX+(distance*(i+1)), 200)
			var anim_sprite = new.get_node("NoteAS")
			anim_sprite.frame = note
			Global.notesOnScreen.append(new)
			add_child(new)
		else:
			Global.notesOnScreen.append(RigidBody2D.new())
	
	for note in Global.notesOnScreen:
		note.linear_velocity = Vector2(-200,0)
		
	inputOn = true

func _on_global_data_ready() -> void:
	if isReady:
		shuffle()
	else:
		await ready
		shuffle()

func _on_spawnstart_timeout() -> void:
	shuffle()
