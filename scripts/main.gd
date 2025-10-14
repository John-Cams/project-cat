extends Node

signal hit(score: int)

var types = [preload("res://assets//Color.png"),preload("res://assets//Shape.png")]
var inputs = ["redHeart","yellowCircle","greenDiamond","blueTriangle"]
const NOTE = preload("res://scenes/note.tscn")
@export var colors: PackedColorArray
var shapes = []
var isReady = false
var minX = 400
var maxX = 1500
var distanceBase = 0
var distance = 0
var first = true
var inputOn = false

#Look at matrix for every line there will be four numbers 1-0 if number is 1 spawn at that location else don't 

func _ready():
	isReady = true
	minX = get_node("Staff/PerfectArea/Perfect").global_position.x
	distanceBase = ((maxX-100)-(minX+100))

func _process(_delta: float) -> void:
	#print(Global.noteLocations)afda
	if !inputOn:
		return
	
	var doContinue = false
	
	##Indexes of important notes
	var inputLocations = []
	##Locations of important notes
	var noteLocations = []
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
	if inputLocations.size()==1:
		location = inputLocations[0]
		score = Global.noteLocations[inputLocations[0]]
	elif inputLocations.size() == 0:
		score -= 1000
		return
	else:
		location = Global.noteLocations.find(Global.noteLocations.max())
		score = Global.noteLocations.max()
	
	if score < 1:
		print("hello")
		changeScore(-1000)
		$Cat.texture = Global.catTextures[1]
		return
	
	if Global.noteComplete[location]:
		return
		
	if Global.notesOnScreen[location].get_child_count() == 0:
		return
	
	Global.noteComplete[location] = true
	var crit = 2 if Global.noteCrit[location] else 1
	
	hit.emit(score)
	$Cat.texture = Global.catTextures[0]
	
	Global.notesOnScreen[location].get_node("NoteAS").visible = false 
	changeScore(score*1000*crit)
	
	
	


func changeScore(add: int):
	Global.score += add
	$Score.text = "Score: " + str(Global.score)

func shuffle():
	inputOn = false
	
	var isShape = false
	
	
	Global.notes = Global.allNotes[Global.currentBar]
	#Global.currentBar += 1
	Global.noteLocations = []
	Global.noteCrit = []
	Global.noteComplete = []
	Global.noteInputs = []
	shapes = []
	
	var distanceDiv = 0
	for i in Global.notes:
		if(i=="1"):
			Global.noteLocations.append(-1)
			Global.noteInputs.append(randi_range(0,3))
			Global.noteCrit.append(randi_range(0,9)==9)
			Global.noteComplete.append(false)
			distanceDiv += 1
		else:
			Global.noteLocations.append(0)
			Global.noteInputs.append(-1)
			Global.noteCrit.append(false)
			Global.noteComplete.append(false)
			distanceDiv += 1 
	
	distance = distanceBase/distanceDiv
	
	
	isShape = (randi_range(0,1)==0)
	$Indicator.texture = types[int(isShape)]
	$Staff/CoolColors.color = colors[int(isShape)]
	
	for i in distanceDiv:
		var crit = (Global.noteCrit[i])
		if(Global.notes[i]=="1"):
			if isShape:
				shapes.append(20+Global.noteInputs[i] if crit else Global.noteInputs[i]+4*randi_range(0,3))
			else:
				shapes.append(16+Global.noteInputs[i] if crit else Global.noteInputs[i]*4+randi_range(0,3))
		else:
			shapes.append(-1) 
	
	
	spawnShapes(shapes)

func spawnShapes(shapeList):
	
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
			if Global.notesOnScreen.size() == 8:
				if !first:
					Global.notesOnScreen.remove_at(3)
					Global.notesOnScreen.remove_at(2)
					Global.notesOnScreen.remove_at(1)
					Global.notesOnScreen.remove_at(0)
				else:
					first = false
		else:
			Global.notesOnScreen.append(RigidBody2D.new())
		
	
			
	
	for note in Global.notesOnScreen:
		note.linear_velocity = Vector2(-distance*(Global.BPM/60.0),0)
		
	inputOn = true

func _on_global_data_ready() -> void:
	if isReady:
		shuffle()
	else:
		await ready
		shuffle()


func _on_spawnstart_timeout() -> void:
	shuffle()
