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

@export
var repeat = false

func _process(delta: float) -> void:
	if repeat:
		print(Global.notesToExpect)

func shuffle() :
	inputsOn = false
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
			for j in Global.requiredInputs.size():
				#print(inputNum == j)
				if inputNum == Global.requiredInputs[j]:
					relevantNotes.append(j)
					#print("input: ",j)
			#print("relNote: ", relevantNotes)
			if relevantNotes.size() == 1:
				if(locations[relevantNotes[0]]):
					theNote = relevantNotes[0]
					#print("single:", theNote)
			elif relevantNotes.size() != 0:
				var relevancy = [0,6,1,5,2,4,3]
				for val in relevancy:
					for note in relevantNotes:
						#print("location: ",locations[note])
						#print("value: ",val)
						if locations[note] == val:
							theNote = note
							break
				
				
			if(theNote != -1):
				nextNote(theNote)
				print(theNote)
					
			#print(Global.requiredInputs)
			#print(Global.notesToExpect)
			#print(locations)
			#print(locations[inputNum])
			#print(inputNum)
			#print(relevantNotes)
			#print(theNote)
			
	
	
	
	
	
	#if inputsOn:
		#var is_valid_input = false
		#print(Global.requiredInputs)
		#print(event.is_action_pressedInputs)
		#print(event in Global.requiredInputs)
		#if event in Global.requiredInputs:
			#var locations = [-1,-1,-1,-1]
			#for i in range(Global.notesToExpect.size()):
				#var item = Global.notesToExpect[i]
				#locations[item] = i
			#print(locations)
		#var x = 1
		#var requiredAction = inputs[Global.requiredInputs[currentShape]]	
		#if event.is_action_pressed(requiredAction):
			#nextNote()
	#for input_action in inputs:
		#if event.is_action_pressed(input_action):
			#is_valid_input = true
			#break 
		#
		#
			#print_debug(event)
	#if inputsOn:
		#var requiredAction = inputs[Global.requiredInputs[currentShape]]	
		#if event.is_action_pressed(requiredAction):
			#nextNote()
		#else:

## This function is ran whenever a note becomes "uselss"
## that is when the note passes the staff bar or is clicked
func nextNote(note) :
	noteHit.emit(note)
	activeShapes[note].visible = false
	activeShapes[note].get_node("NoteCS").disabled = true
	
	#print("yes" + str(currentShape))
	if note == 3:
		shuffle()
		note = -1
	note += 1
	Global.currentNote = note
			
func _ready() -> void:
	shuffle()
	
func spawnShapes(shapeList) :
	var distance = (xStaffMax - xStaffMin) / (shapeList.size())
	for i in shapeList.size():
		await $Timer.timeout
		var new = $Note.duplicate()
		new.position = Vector2(xStaffMin + (300*i), 200)
		var anim_sprite: AnimatedSprite2D = new.get_node("NoteAS")
		anim_sprite.frame = shapes[i]
		add_child(new)
		activeShapes.append(new)
	
	for i in activeShapes:
		i.linear_velocity = Vector2(-300, 0)
	
	inputsOn = true	
	



#func _on_area_2d_entered() -> void:
	#print("hi")


func _on_staff_area_complete_miss() -> void:
	shuffle()
