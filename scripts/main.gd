extends Node

var types = [preload("res://assets//Color.png"),preload("res://assets//Shape.png")]
var inputs = ["redHeart","yellowCircle","greenDiamond","blueTriangle"]
var colors = ["#FF8888","#FFFF88","#88FF88","8888FF"]
var shapes = []
var isReady = false
var minX = 400
var maxX = 1500
var distanceBase = 0
var distance = 0

#Look at matrix for every line there will be four numbers 1-0 if number is 1 spawn at that location else don't 
#

func _ready():
	isReady = true
	minX = get_node("Staff/PerfectArea/Perfect").global_position.x
	distanceBase = ((maxX-100)-(minX+100))

func _input(event):
	if event.is_action_pressed("spaceBar"):
		$ColorRect.visible = false
		shuffle()
		
func shuffle():
	
	var isShape = false
	
	
	Global.notes = Global.allNotes[Global.currentBar]
	Global.noteLocations = []
	Global.noteCrit = []
	Global.noteComplete = []
	
	var distanceDiv = 0
	for i in Global.notes:
		if(i=="1"):
			Global.noteLocations.append(null)
			Global.noteInputs.append(randi_range(0,3))
			Global.noteCrit.append(randi_range(1,10)==10)
			Global.noteComplete.append(false)
			distanceDiv += 1
		else:
			Global.noteLocations.append(null)
			Global.noteInputs.append(-1)
			Global.noteCrit.append(null)
			Global.noteComplete.append(true)
		
	distance = distanceBase/distanceDiv
			
	
	
	isShape = (randi_range(0,1)==0)
	$Indicator.texture = types[int(isShape)]
	
	print(Global.allNotes)
	for i in distanceDiv:
		print(i)
		if(Global.notes[i]=="1"):
			if isShape:
				shapes.append(Global.noteInputs[i]+4*randi_range(0,3))
			else:
				shapes.append(Global.noteInputs[i]*4+randi_range(0,3))
		else:
			shapes[i] = -1 

	print(Global.notes)	
	print(shapes)
	
	spawnShapes(shapes)
	
	


func spawnShapes(shapeList):	
	print(distance)
	for i in shapeList.size():
		var note = shapeList[i]
		var new = $Note.duplicate()
		new.position = Vector2(minX+(distance*(i+1)), 200)
		var anim_sprite: AnimatedSprite2D = new.get_node("NoteAS")
		anim_sprite.frame = note
		add_child(new)

func _on_global_data_ready() -> void:
	if isReady:
		shuffle()
	else:
		await ready
		shuffle()
