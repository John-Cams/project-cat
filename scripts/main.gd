extends Node

@onready
var types = [preload("res://assets//Color.png"),preload("res://assets//Shape.png")]
var inputs = ["redHeart","yellowCircle","greenDiamond","blueTriangle"]
var colors = ["#FF8888","#FFFF88","#88FF88","8888FF"]

#Look at matrix for every line there will be four numbers 1-0 if number is 1 spawn at that location else don't 
#


func _input(event):
	if event.is_action_pressed("spaceBar"):
		$ColorRect.visible = false
		shuffle()
		
func shuffle():
	
	var isShape = false
	
	Global.notes = []
	Global.noteLocations = []
	Global.noteCrit = []
	Global.noteComplete = []
	
	
	Global.noteInputs = [randi_range(0,3), randi_range(0,3), randi_range(0,3), randi_range(0,3)]
	isShape = (randi_range(0,1)==0)
	$Indicator.texture = types[int(isShape)]
	
	
	
