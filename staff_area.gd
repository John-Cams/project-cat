extends Area2D

signal entered

#func _on_body_entered(body) -> void:
	#entered.emit()
	#print("hi")

var temp = 0

func _ready():
	set_monitoring(true)
	# Connect the signal that tells you which shape of the Area2D was hit
	#self.body_shape_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	# body -> the RigidBody2D that entered
	# body_shape_index -> the shape index of the body that hit you
	# local_shape_index -> the index of your Area2D's CollisionShape2D that was hit
	#var collided_shape = self.get_child(local_shape_index)
	#print("RigidBody entered shape: ", collided_shape.name)
	print("hi")

func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int):
	
	Global.listOfNotes.append(body_shape_index)
	
	
	temp += 1
	print(body_shape_index, local_shape_index)
