extends Node



func _on_button_pressed() -> void:
	print("wah")
	get_tree().change_scene_to_file("res://scenes/game.tscn")
