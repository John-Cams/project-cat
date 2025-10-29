extends Node2D

signal notePressed(note:int)

var listOfSongs = []
var currentSong = 0
var listOfNotes = []
var noteToSwitch = 0

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
	currentSong = song
	for i in listOfSongs[currentSong].noteQueue.size():
		var newNote = $NoteBlock.duplicate()
		listOfNotes.append(newNote)
		newNote.get_node("Number").text = str(i+1)
		newNote.get_node("Note").frame = listOfSongs[currentSong].noteQueue[i]
		newNote.get_node("Dir").rotation = listOfSongs[currentSong].direction[i]*(PI/2)
		var dirPos
		match listOfSongs[currentSong].direction[i]:
			0:
				dirPos = Vector2(0,200)
			1: 
				dirPos = Vector2(100,200)
			2:
				dirPos = Vector2(100, 300)
			3:
				dirPos = Vector2(0, 300)
		
		newNote.get_node("Dir").position = dirPos
		newNote.global_position += Vector2(100*i, 0)
		newNote.visible = true
		newNote.get_node("NoteBTN").pressed.connect(_on_note_pressed.bind(i))
		add_child(newNote)


func _on_note_pressed(note: int) -> void:
	$NotePicker.visible = true
	$NotePicker.global_position = listOfNotes[note].get_node("BGNote").global_position
	noteToSwitch = note


func _on_control_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		var localPos = event.position
		listOfNotes[noteToSwitch].get_node("Note").frame = ( (floor(localPos.x/100))+(floor(localPos.y/100))*4 )
		$NotePicker.visible = false
