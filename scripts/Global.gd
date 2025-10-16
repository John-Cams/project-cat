extends Node

#var listOfNotesAvailable = [-1,-1,-1,-1]
#var currentNote = 0
#var notesToExpect = [-1,-1,-1,-1,-1,-1,-1]
#var requiredInputs = [0,0,0,0]
#var finished = []
#var score = 0

#TODO Implement these do actually work
signal dataReady

var chart = preload("res://charts//test.tres")
var allNotes = []

var catTextures = [preload("res://assets/happyCat.png"),preload("res://assets/sadCat.png")]
var controlTextures = [preload("res://assets/Red.png"),preload("res://assets/Yel.png"),preload("res://assets/Gre.png"),preload("res://assets/Blu.png")]

var currentBar = 0
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
##The maximum score
var maxScore = 0

var BPM = 0
var score = 0

func _ready():
	

	var text = chart.notes
	BPM = chart.BPM
	
	var _temp = 0
	allNotes.append([])
	for i in text:
		if(i=="|"):
			allNotes.append([])
			currentBar += 1
		else:
			allNotes[currentBar].append(i)
				
	for bar in allNotes:
		for note in bar:
			if int(note) == 2:
				maxScore += 6000
			elif int(note) == 1:
				maxScore += 3000
	print(maxScore)
	currentBar = 0
	BPM = int(BPM)
	dataReady.emit()
