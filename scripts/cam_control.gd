extends Node

@export var currentScreen:int
@export var camera: Camera2D

var screens = [Vector2(800,500),Vector2(800,1500),Vector2(800,2500)]


func _process(_delta: float) -> void:
	if camera == null:
		return
	camera.global_position = screens[currentScreen]
