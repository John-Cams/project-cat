extends Area2D

signal entered

func _on_body_entered(body) -> void:
	entered.emit()
	print("hi")
	
