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

var catTextures = [preload("res://assets/happyCat.png"),preload("res://assets/sadCat.png")]

var currentBar = -1
##String either 1 or 0
var notes = []
##Node the notes on screen
var notesOnScreen = []
##Int 1-7 and -1
var noteLocations = []
##Int 0-3
var noteInputs = []
##True false or null
var noteCrit = []
##Int 1-7 and -1
var noteComplete = []

var BPM = 0
var score = 0

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
