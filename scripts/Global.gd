extends Node

#var listOfNotesAvailable = [-1,-1,-1,-1]
#var currentNote = 0
#var notesToExpect = [-1,-1,-1,-1,-1,-1,-1]
#var requiredInputs = [0,0,0,0]
#var finished = []
#var score = 0

#TODO Implement these do actually work
var filePath = 'res://charts/MelodyTut.txt'
var allNotes = []

var notes = []
var noteLocations = []
var noteInputs = []
var noteCrit = []
var noteComplete = []

func _ready():
	print("Hello")
	var text = load_text(filePath)
	var currentBar = -1
	var appendTime = false
	for i in text:
		if(i=="/"):
			allNotes.append([])
		elif(i=="|"):
			appendTime = true
			currentBar += 1
			allNotes.append([])
		elif(i=="\\"):
			appendTime=false
		else:
			allNotes[currentBar].append(i)
	print(allNotes)
			
	
		
	
	
func load_text(path: String) -> String:
	if not FileAccess.file_exists(path):
		push_error("File not found: " + path)
		return ""

	var file := FileAccess.open(path, FileAccess.READ)
	var content := file.get_as_text()
	file.close()
	return content
