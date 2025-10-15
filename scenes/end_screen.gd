extends Node

func _ready() -> void:
	$Label.text = ("Score: " + str(Global.score))
	
func _process(_2delta: float) -> void:
	for i in ["redHeart","yellowCircle","greenDiamond","blueTriangle"]:
		if Input.is_action_just_pressed(i):
			$Button.emit_signal("pressed")


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	Global.currentBar = 0
	Global.score = 0
	Global.notesOnScreen = []
 # Replace with function body.
