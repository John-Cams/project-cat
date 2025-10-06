extends Area2D

signal entered
signal completeMiss

#func _on_body_entered(body) -> void:
	#entered.emit()
	#print("hi")

var temp = 0
var amountMissed = 0

func _ready():
	set_monitoring(true)
	# Connect the signal that	 tells you which shape of the Area2D was hit
	#self.body_shape_entered.connect(_on_body_entered)

#func _on_body_entered(body: Node) -> void:
	# body -> the RigidBody2D that entered
	# body_shape_index -> the shape index of the body that hit you
	# local_shape_index -> the index of your Area2D's CollisionShape2D that was hit
	#var collided_shape = self.get_child(local_shape_index)
	#print("RigidBody entered shape: ", collided_shape.name)
	#print("hi")

func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int):
	if (!(local_shape_index==7)):
		Global.notesToExpect[local_shape_index] += 1	
		temp += 1
		#print(notesToExpect)
		Global.listOfNotesAvailable[Global.notesToExpect[local_shape_index]] = local_shape_index
	else:
		Global.finished.append(Global.notesToExpect[6])
		Global.listOfNotesAvailable[Global.notesToExpect[6]] = -1
		amountMissed += 1
		if Global.finished.size() == 4:
			Global.finished == []
			completeMiss.emit()
	
#func _on_body_shape_exited(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int):
	#print(body)
	#if (!(local_shape_index==7)):
		#Global.notesToExpect[local_shape_index] 


#func _on_main_note_hit(note: int):
	#print(Global.notesToExpect)
	
func _on_main_shuffle_sig() -> void:
	Global.notesToExpect = [-1,-1,-1,-1,-1,-1,-1]
	Global.listOfNotesAvailable = [-1,-1,-1,-1]
	
func unique_list(list):
	var unique = []
	for i in list:
		if !(i in list):
			unique.append(i)
	
