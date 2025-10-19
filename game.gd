extends Node

##The name of the inputs
var inputs = ["redHeart","yellowCircle","greenDiamond","blueTriangle"]
##Note scene
const NOTE = preload("res://scenes/note.tscn")
##Notes
var notes = []
##Shape or color
var isShape = false
##Ready
var isReady = false

##List of notes that need to be hit
var queue = []

var uh = false

func _process(delta: float) -> void:
	var inputPressed = false
	var inputName = -1
	var wait = 0
	var wait2 = 0
	for i in inputs.size():
		if(Input.is_action_pressed(inputs[i])):
			inputName = i
			if(isShape):
				$VerticIndicator.visible = true
				$VerticIndicator.frame = i
				$VerticIndicator.position = Vector2(650+(i*100),500)
			else:
				$HorizIndicator.visible = true
				$HorizIndicator.frame = i
				$HorizIndicator.position = Vector2(800,350+(i*100))
			
			inputPressed = inputPressed or Input.is_action_just_pressed(inputs[i])
			wait = 100
	if(!inputPressed):
		var currentBar = [$HorizIndicator,$VerticIndicator][int(isShape)]
		if wait==0:
			currentBar.visible = false
		else:
			wait -= 1
		[$HorizIndicator,$VerticIndicator][int(!isShape)].visible = false
		
	if(inputPressed):
		if isShape:
			print(650+(inputName*100) == notes[notes.size()-1].scorePos.x)
		else:
			print(350+(inputName*100) == notes[notes.size()-1].scorePos.y)
		#if $Background.color == Color(1.0, 1.0, 1.0, 1.0):
			#$Background.color = Color(0.0, 1.0, 1.0, 1.0)
	
	if !notes.is_empty():
		
		for i in notes:
			var move = i.direction*500*delta
			i.position += move
			if abs(notes[notes.size()-1].scorePos.x - notes[notes.size()-1].position.x) <= 50 and abs(notes[notes.size()-1].scorePos.y - notes[notes.size()-1].position.y) <= 50:
				#print(true)
				wait2 = 100
				#if $Background.color != Color(0.0, 1.0, 1.0, 1.0):
					#$Background.color = Color(1.0, 1.0, 1.0, 1.0)
			else:
				if wait2 == 0:
					#$Background.color = Color()
					var x
				else:
					wait2 -= 1
		
	
		
func _ready() -> void:
	isReady = true

func createNote(row: int, col: int):
	
	var newNote = NOTE.instantiate() 
	newNote.frame = (row*4+col)
	newNote.visible = true
	queue.append(newNote)
	add_child(newNote)
	var isLeftTop = (randi_range(0,1)==0)
	
	# -100, 650+(col*100), 1700
	# -100. 350+(row*100), 1100
	var xVal = 0
	var yVal = 0
	var direction = Vector2.DOWN
	if (!isLeftTop)and(isShape):
		#Offscreen
		xVal = 650+(col*100)-400
		yVal = 350+(row*100)
		direction = Vector2.RIGHT
	elif (!isLeftTop)and(!isShape):
		xVal = 650+(col*100)
		#Offscreen
		yVal = 350+(row*100)-400
		direction = Vector2.DOWN
	elif (isLeftTop)and(isShape):
		#Offscreen
		xVal = 650+(col*100)+400
		yVal = 350+(row*100)
		direction = Vector2.LEFT
	else:
		xVal = 650+(col*100)
		#Offscreen
		yVal = 350+(row*100)+400
		direction = Vector2.UP
	
	newNote.startPos = Vector2(xVal, yVal)
	newNote.direction = direction
	newNote.scorePos = Vector2(650+(col*100),350+(row*100))
	$AnimatedSprite2D.global_position = Vector2(650+(col*100),350+(row*100))
	newNote.inputs = [row, col]
	newNote.global_position = newNote.startPos
	#newNote.global_position = Vector2(xVal, yVal)
	notes.append(newNote)

func _on_change_timeout() -> void:
	isShape = !isShape

func _on_spawn_timeout() -> void:
	if isReady:
		createNote(randi_range(0,3),randi_range(0,3))
