extends Node

@export var currentScreen:int
@export var camera: Camera2D
@export var rect: ColorRect

var screens = [Vector2(800,500),Vector2(800,1500),Vector2(800,2500)]
var color = Color.from_hsv(0.4, 0.21, 0.52, 1.0)
var newH = 0.4
var increment = 0.1


func _process(_delta: float) -> void:
	if camera == null:
		return
	camera.global_position = screens[currentScreen]
	
	color = Color.from_hsv(color.h+0.001, color.s, color.v, 1.0)
	rect.color = color
