extends Node

#var listOfNotesAvailable = [-1,-1,-1,-1]
#var currentNote = 0
#var notesToExpect = [-1,-1,-1,-1,-1,-1,-1]
#var requiredInputs = [0,0,0,0]
#var finished = []
#var score = 0

#TODO Implement these do actually work
signal dataReady

var filePath = 'res://charts/MelodyTut.txt'
var allNotes = []

var currentBar = -1
var notes = []
var notesOnScreen = []
var noteLocations = []
var noteInputs = []
var noteCrit = []
var noteComplete = []
var BPM = 0

func _ready():
	
	if not FileAccess.file_exists(filePath):
		push_error("File not found: " + filePath)
		return ""

	var file = FileAccess.open(filePath, FileAccess.READ)
	var text = file.get_as_text()
	file.close()
	BPM = ""
	
	var appendTime = false
	var _temp = 0
	for i in text:
		if(i=="/"):
			#allNotes.append([])
			_temp = 0
		elif(i=="|"):
			appendTime = true
			allNotes.append([])
			currentBar += 1
		elif(i=="\\"):
			appendTime=false
		else:
			if(appendTime):
				allNotes[currentBar].append(i)
			else:
				BPM += i
	currentBar = 0
	BPM = int(BPM)
	dataReady.emit()
