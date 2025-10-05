extends Node

signal noteHit(hit: int)
signal shuffleSig

@onready
var types = [preload("res://assets//Shape.png"),preload("res://assets//Color.png")]
var inputs = ["redHeart","yellowCircle","greenDiamond","blueTriangle"]
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
	if inputsOn:
		var inputNum = -1
		var validInput = false
		for i in inputs:
			validInput = event.is_action_pressed(i) or validInput
			if event.is_action_pressed(i):
				inputNum = inputs.find(i)
		if validInput:
			var locations = [-1,-1,-1,-1]
			for i in range(Global.notesToExpect.size()):
				var item = Global.notesToExpect[i]
				if item != -1:
					locations[item] = i
					
			var relevantNotes = []
			var theNote = -1
			var theNoteLocation = -1
			var relevancy = [0,6,1,5,2,4,3]
			for j in Global.requiredInputs.size():
				#print(inputNum == j)
				if inputNum == Global.requiredInputs[j]:
					relevantNotes.append(j)
					#print("input: ",j)
			#print("relNote: ", relevantNotes)
			if relevantNotes.size() == 1:
				if(locations[relevantNotes[0]]):
					theNote = relevantNotes[0]
					theNoteLocation = relevancy.find(locations[relevantNotes[0]])
					#print("single:", theNote)
			elif relevantNotes.size() != 0:
				for val in relevancy:
					for note in relevantNotes:
						#print("location: ",locations[note])
						#print("value: ",val)
						if locations[note] == val:
							theNote = note
							theNoteLocation = relevancy.find(locations[relevantNotes[0]])
							break
			if(theNote != -1):
				nextNote(theNote)
				Global.score += (theNoteLocation+1)*100
				print(theNoteLocation)
				print(Global.score)
				$Score.text = "Score:" + str(Global.score)
				#print(theNote)

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
		
			
func _ready() -> void:
	shuffle()
	
func spawnShapes(shapeList):	
	if(notStarted):
		notStarted = false
		var distance = (xStaffMax - xStaffMin) / (shapeList.size())
		for i in shapeList.size():
			await $Timer.timeout
			if!($Music.playing):
				$Music.play()
			var new = $Note.duplicate()
			new.position = Vector2(xStaffMin + (300*i), 200)
			var anim_sprite: AnimatedSprite2D = new.get_node("NoteAS")
			anim_sprite.frame = shapes[i]
			add_child(new)
			activeShapes.append(new)
		for i in activeShapes:
			i.linear_velocity = Vector2(-300, 0)
		inputsOn = true	
	else:
		await $Spawnstart.timeout
		print("Wak")
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
