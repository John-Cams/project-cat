extends Node

##The name of the inputs
var inputs = ["redHeart","yellowCircle","greenDiamond","blueTriangle"]
##Note scene
const NOTE = preload("res://scenes/note.tscn")
##Notes
var notes = []
##Shape or color
@export var isShape = false
##Ready
var isReady = false
##Score
var score = 0
##Allow inputs
var allowInputs = true
##Current note
var currentNote = 0
##Note list spawn
var noteList = [[0,0]]
##Wait time
var spawnTime = (60.0/140.0)
##Triggers once the music 
var firstTime = false

var chart = preload("res://charts/Song 1.tres")

var izHorz = false

##List of notes that need to be hit
var queue = []

var uh = false

func _process(delta: float) -> void:
	var inputPressed = false
	var inputName = -1
	var wait = 0
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
			
			inputPressed = inputPressed or Input.is_action_just_pressed(inputs[i]) and allowInputs
			wait = 100
	if(!inputPressed):
		var currentBar = [$HorizIndicator,$VerticIndicator][int(isShape)]
		if wait==0:
			currentBar.visible = false
		else:
			wait -= 1
		[$HorizIndicator,$VerticIndicator][int(!isShape)].visible = false
	
	if !notes.is_empty():
		isShape = (notes[notes.size()-1].direction.y==0)
		for i in notes:
			var move = i.direction*500*delta
			i.position += move
			
			#If note input pressed and note is close kill note
			if(inputPressed):
				if(inputName == i.desiredInput()):
					if abs(i.scorePos.x - i.position.x) <= 50 and (i.scorePos.y - i.position.y) <= 50:
						print(i.scorePos)
						changeScore(100 * (50- ((abs(i.scorePos.x) - i.position.x)+(abs(i.scorePos.y) - i.position.y))))
						i.visible = false


func changeScore(change: int):
	score += change
	$Score.text = "Score: " + str(score)
	
func _ready() -> void:
	isReady = true
	$Spawn.wait_time = spawnTime
	for i in chart.noteQueue.size():
		noteList.append([chart.noteQueue[i],chart.direction[i]])
	noteList = chart.noteQueue
	
	
func pauseInputs():
	allowInputs = false
	$Allow.start()

func createNote(row: int, col: int, isLeftTop: bool, isHorz: bool):
	
	isLeftTop = randi_range(0,4)
	isHorz = randi_range(0,4)
	row = randi_range(0,4)
	col = randi_range(0,4)
	var newNote = NOTE.instantiate() 
	newNote.frame = (row*4+col)
	newNote.visible = true
	queue.append(newNote)
	add_child(newNote)
	
	
	isLeftTop = chart.direction[currentNote] != 2 and chart.direction[currentNote] != 3
	isHorz = chart.direction[currentNote]%2 == 1
	
	# -100, 650+(col*100), 1700
	# -100. 350+(row*100), 1100
	var xVal = 0
	var yVal = 0
	var direction = Vector2.DOWN
	if (!isLeftTop)and(isHorz):
		#Offscreen
		xVal = 650+(col*100)-400
		yVal = 350+(row*100)
		direction = Vector2.RIGHT
	elif (!isLeftTop)and(!isHorz):
		xVal = 650+(col*100)
		#Offscreen
		yVal = 350+(row*100)-400
		direction = Vector2.DOWN
	elif (isLeftTop)and(isHorz):
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

func _on_spawn_timeout() -> void:
	if isReady and currentNote!=noteList.size():
		if !firstTime:
			$SongPlayer.play()
			firstTime = true
		createNote(chart.noteQueue[currentNote]%4,chart.noteQueue[currentNote]/4, true, izHorz)
		if (currentNote!=chart.noteQueue.size()-1):
			currentNote += 1
		else:
			currentNote = 0

func _on_allow_timeout() -> void:
	allowInputs = true
	$Allow.stop()
	
