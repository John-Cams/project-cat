extends Node

signal noteHit(hit: int)
signal shuffleSig

@onready
var types = [preload("res://assets//Shape.png"),preload("res://assets//Color.png")]
var inputs = ["redHeart","yellowCircle","greenDiamond","blueTriangle"]
var colors = ["#FF8888","#FFFF88","#88FF88","8888FF"]
var currentShape = 0
var isShape = true
#TODO Change later
var xStaffMin = 400
var xStaffMax = 1700
var shapes = [0,0,0,0]
var activeShapes = []
var inputsOn = false
var time = 0
var notStarted = true
var timingList = [8, 2, 2, 2, 2]

#Game timeline
#TODO make a list of every variable
#TODO make a list of every signal 



#TODO
#	Make a different note lists with attributes
#		Lucky?
#		Input num?
#		Location
#		Useful
# Figure out how to make custom notes timing
# BPM
# If speed = 100 bpm then each note should be move




@export
var repeat = true

#func _process(delta: float) -> void:
	#if repeat:
		#print(Global.finished)

func shuffle() :
	inputsOn = false
	Global.finished = []
	Global.notesToExpect = [-1,-1,-1,-1,-1,-1,-1]
	shuffleSig.emit()
	Global.requiredInputs = [randi_range(0,3),randi_range(0,3),randi_range(0,3),randi_range(0,3)]
	isShape = (randi_range(0,1)==0)
	$Indicator.texture = types[int(!isShape)]
	#print(Global.requiredInputs)
	
	for s in activeShapes:
		s.queue_free()
	activeShapes.clear()
	
	for i in shapes.size(): #TODO Change 4 to length of array
		if isShape:
			shapes[i] = Global.requiredInputs[i]+4*randi_range(0,3)
		else:
			shapes[i] = Global.requiredInputs[i]*4+randi_range(0,3)
	
	spawnShapes(shapes)
	#print(shapes)

func _input(event):
	if event.is_action_pressed("spaceBar"):
		$ColorRect.visible = false
		shuffle()
	#Check if inputs are on
	
	if inputsOn:
		
		var inputNum = -1
		for i in inputs:
			if event.is_action_pressed(i):
				inputNum = inputs.find(i)
		
		if inputNum != -1:
			$StaffArea/CoolColors.color =  colors[inputNum]
			print(inputNum)
			#Check if input is needed inputs
			if inputNum in Global.requiredInputs:
				
				#Creates a list of every notes location
				var locations = [-1,-1,-1,-1]
				for i in range(Global.notesToExpect.size()):
					var item = Global.notesToExpect[i]
					if item != -1:
						locations[item] = i
					
				#Create a list of notes that match the input
				var importantNotes = []
				var importantLocations = []
				for i in Global.requiredInputs.size():
					if inputNum == Global.requiredInputs[i]:
						importantNotes.append(inputNum)
					
				#Find the item that is the closest to three
				var theNote = -1
				for i in [0,6,1,5,2,4,3]:
					for j in importantNotes.size():
						if locations[j] == i:
							theNote = importantNotes[j]
			
				if theNote != -1:
					nextNote(theNote)
			
				print(theNote)
	
	
	
	
	
	
	
	#if inputsOn:
		#var inputNum = -1
		#var validInput = false
		#
		##Is input in the list of 
		#for i in inputs:
			#validInput = event.is_action_pressed(i) or validInput
			#if event.is_action_pressed(i):
				#inputNum = inputs.find(i)
		#if validInput:
			#var locations = [-1,-1,-1,-1]
			#for i in range(Global.notesToExpect.size()):
				#var item = Global.notesToExpect[i]
				#if item != -1:
					#locations[item] = i
					#
			#var relevantNotes = []
			#var theNote = -1
			#var theNoteLocation = -1
			#var relevancy = [0,6,1,5,2,4,3]
			#for j in Global.requiredInputs.size():
				##print(inputNum == j)
				#if inputNum == Global.requiredInputs[j]:
					#relevantNotes.append(j)
					##print("input: ",j)
			##print("relNote: ", relevantNotes)
			#if relevantNotes.size() == 1:
				#if(locations[relevantNotes[0]]):
					#theNote = relevantNotes[0]
					#theNoteLocation = relevancy.find(locations[relevantNotes[0]])
					##print("single:", theNote)
			#elif relevantNotes.size() != 0:
				#for val in relevancy:
					#for note in relevantNotes:
						##print("location: ",locations[note])
						##print("value: ",val)
						#if locations[note] == val:
							#theNote = note
							#theNoteLocation = relevancy.find(locations[relevantNotes[0]])
							#break
			#if(theNote != -1) or (locations[theNote] != -1):
				#
				#nextNote(theNote)
				#Global.score += (theNoteLocation+1)*100
				#print(theNote)
				#print(theNoteLocation)
				#print(Global.score)
				#$Score.text = "Score:" + str(Global.score)
				##print(theNote)
				#

## This function is ran whenever a note becomes "uselss"
## that is when the note passes the staff bar or is clicked
func nextNote(note) :
	noteHit.emit(note)
	activeShapes[note].visible = false
	activeShapes[note].get_node("NoteCS").disabled = true
	Global.finished.append(note)
	
	#print("yes" + str(currentShape))
	if Global.finished.size() == 4:
		await $Timer.timeout
		shuffle()

func spawnShapes(shapeList):	
	if(notStarted):
		notStarted = false
		var distance = (xStaffMax - xStaffMin) / (shapeList.size())
		for i in shapeList.size():
			await $Timer.timeout
			var new = $Note.duplicate()
			new.position = Vector2(xStaffMin + (distance*i), 200)
			var anim_sprite: AnimatedSprite2D = new.get_node("NoteAS")
			anim_sprite.frame = shapes[i]
			add_child(new)
			activeShapes.append(new)
		for i in activeShapes:
			i.linear_velocity = Vector2(-300, 0)
		inputsOn = true	
	else:
		await $Spawnstart.timeout
		notStarted=true
		spawnShapes(shapeList)
	



#func _on_area_2d_entered() -> void:
	#print("hi")

func _on_staff_area_complete_miss() -> void:
	shuffle()

func _on_audio_stream_player_finished() -> void:
	$Music.play()

func _on_timer_timeout() -> void:
	#print_debug("Hi")
	time += 1
