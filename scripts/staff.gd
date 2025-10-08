extends Sprite2D

var areas = []

func _ready():
	for child in get_children():
		if child is Area2D:
			child.connect("body_entered", Callable(self, "_on_area_entered").bind(child))
			areas.append(child.name)

func _on_area_entered(body: Node, area: Area2D):
	var areaNum = areas.find(area.name)
	var shapeNum = Global.notesOnScreen.find(body)
	if areaNum == 0:
		Global.noteLocations[shapeNum] = -1
	else:
		Global.noteLocations[shapeNum] = areaNum
	
