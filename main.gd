extends Node

signal noteHit
signal shuffleSig

@onready
var types = [preload("res://assets//Shape.png"),preload("res://assets//Color.png")]
var requiredInputs = [0,0,0,0]
var inputs = ["redHeart","yellowCircle","greenDiamond","blueTriangle"]
var currentShape = 0
var isShape = true
#TODO Change later
var xStaffMin = 400
var xStaffMax = 1700
var shapes = [0,0,0,0]
var activeShapes = []
var inputsOn = false

func _process(delta: float) -> void:
	print(inputsOn)

func shuffle() :
	inputsOn = false
	shuffleSig.emit()
	requiredInputs = [randi_range(0,3),randi_range(0,3),randi_range(0,3),randi_range(0,3)]
	isShape = (randi_range(0,1)==0)
	$Indicator.texture = types[int(!isShape)]
	print(requiredInputs)
	
	for s in activeShapes:
		s.queue_free()
	activeShapes.clear()
	
	for i in shapes.size(): #TODO Change 4 to length of array
		if isShape:
			shapes[i] = requiredInputs[i]+4*randi_range(0,3)
		else:
			shapes[i] = requiredInputs[i]*4+randi_range(0,3)
	
	spawnShapes(shapes)
	print(shapes)
	
func _input(event):
	if inputsOn:
		var requiredAction = inputs[requiredInputs[currentShape]]	
		if event.is_action_pressed(requiredAction):
			nextNote()
		else:
			var is_valid_input = false
			for input_action in inputs:
				if event.is_action_pressed(input_action):
					is_valid_input = true
					break 
			if is_valid_input:
				print("No")

## This function is ran whenever a note becomes "uselss"
## that is when the note passes the staff bar or is clicked
func nextNote() :
	noteHit.emit()
	activeShapes[currentShape].visible = false
	activeShapes[currentShape].get_node("NoteCS").disabled = true
	
	print("yes" + str(currentShape))
	if currentShape == 3:
		shuffle()
		currentShape = -1
	currentShape += 1
	Global.currentNote = currentShape
			
func _ready() -> void:
	shuffle()
	
func spawnShapes(shapeList) :
	var distance = (xStaffMax - xStaffMin) / (shapeList.size())
	for i in shapeList.size():
		await $Timer.timeout
		var new = $Note.duplicate()
		new.position = Vector2(xStaffMin + (300*i), 200)
		var anim_sprite: AnimatedSprite2D = new.get_node("NoteAS")
		anim_sprite.frame = shapes[i]
		add_child(new)
		activeShapes.append(new)
	
	for i in activeShapes:
		i.linear_velocity = Vector2(-300, 0)
	
	inputsOn = true	
	



func _on_area_2d_entered() -> void:
	print("hi")


func _on_staff_area_complete_miss() -> void:
	shuffle()
