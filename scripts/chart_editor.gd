extends Node2D

signal notePressed(note:int)
signal dirPressed(note: int)

var listOfSongs = []
var currentSong = 0
var listOfNotes = []
var noteToSwitch = 0
var dirPoss = [Vector2(0,200),Vector2(100,200),Vector2(100,300),Vector2(0,300)]
var lastXVal = 0
var tempFile:Chart

func _ready() -> void:
	var dir := DirAccess.open("res://charts")
	if dir:
		dir.list_dir_begin()
		var file_name: String = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				# Construct the full path to the resource
				var file_path: String = "res://charts" + "/" + file_name
				# Load the resource if it's a recognized resource type
				if ResourceLoader.exists(file_path):
					var resource = load(file_path)
					if resource:
						listOfSongs.append(resource)
				file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("Could not open directory: " + "res://charts")

func _on_chart_list_change_song(song:int) -> void:

	for i in listOfNotes:
		i.queue_free()
	listOfNotes = []
	tempFile = listOfSongs[currentSong]
	currentSong = song
	for i in listOfSongs[currentSong].noteQueue.size():
		var newNote = $NoteList/NoteBlock.duplicate()
		listOfNotes.append(newNote)
		newNote.get_node("Number").text = str(i+1)
		newNote.get_node("Note").frame = listOfSongs[currentSong].noteQueue[i]
		newNote.get_node("Dir").rotation = listOfSongs[currentSong].direction[i]*(PI/2)
		newNote.get_node("Dir").position = dirPoss[listOfSongs[currentSong].direction[i]]
		newNote.global_position += Vector2(100*i, 0)
		newNote.visible = true
		newNote.get_node("NoteBTN").pressed.connect(_on_note_pressed.bind(i))
		newNote.get_node("DirBTN").pressed.connect(_on_dir_pressed.bind(i))
		$NoteList.add_child(newNote)
		lastXVal = newNote.position.x
	$NoteList/NewNote.position = Vector2(lastXVal+100, $NoteList/NewNote.position.y)


func _on_note_pressed(note: int) -> void:
	$NotePicker.visible = true
	$NotePicker.global_position = listOfNotes[note].get_node("BGNote").global_position
	noteToSwitch = note

func _on_dir_pressed(note: int) -> void:
	#listOfNotes[note].get_node("Dir").rotation = (listOfNotes[note].get_node("Dir").rotation+PI/2)
	listOfNotes[note].get_node("Dir").rotation = fmod((listOfNotes[note].get_node("Dir").rotation+PI/2),(2*PI))
	listOfNotes[note].get_node("Dir").position = dirPoss[((2/PI)*listOfNotes[note].get_node("Dir").rotation)]
	

func _on_control_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		var localPos = event.position
		listOfNotes[noteToSwitch].get_node("Note").frame = ( (floor(localPos.x/100))+(floor(localPos.y/100))*4 )
		tempFile.noteQueue[noteToSwitch] = ( (floor(localPos.x/100))+(floor(localPos.y/100))*4 )
		$NotePicker.visible = false
			
func _process(_delta: float) -> void:
	if Input.is_action_pressed("redHeart"):
		CamControl.camera.position += Vector2(0,1)
	if Input.is_action_pressed("greenDiamond"):
		CamControl.camera.position += Vector2(0,-1)
	if Input.is_action_pressed("yellowCircle"):
		CamControl.camera.position += Vector2(1,0)
	if Input.is_action_pressed("blueTriangle"):
		CamControl.camera.position += Vector2(-1,0)
	print($NoteList.position," ", lastXVal)

func _on_new_note_pressed() -> void:
	var newNote = $NoteList/NoteBlock.duplicate()
	listOfNotes.append(newNote)
	newNote.position = Vector2(lastXVal+100,0)
	lastXVal += 100
	newNote.get_node("NoteBTN").pressed.connect(_on_note_pressed.bind((lastXVal+100)/100-1))
	newNote.get_node("DirBTN").pressed.connect(_on_dir_pressed.bind((lastXVal+100)/100-1))
	$NoteList.add_child(newNote)
	newNote.get_node("Number").text = str(listOfNotes.size())
	$NoteList/NewNote.position = Vector2(lastXVal+100, $NoteList/NewNote.position.y)
	$NoteList.position += Vector2(-100,0)


func _on_left_pressed() -> void:
	if($NoteList.position.x == lastXVal*-1):
		return
	$NoteList.position += Vector2(-100,0)


func _on_right_pressed() -> void:
	if($NoteList.position.x == 1400):
		return
	$NoteList.position += Vector2(100,0)


func _on_button_pressed() -> void:
	CamControl.currentScreen = 1
