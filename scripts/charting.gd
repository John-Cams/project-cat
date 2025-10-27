extends Node

signal RH
signal YC
signal GD
signal BT


var currentChart: Chart
var currentScreen = 2
var screens = ["EditCreate", "ChartList"] 
var yPosList = [195,295,425,585,715]
var scaleList = [0.6,0.8,1,0.8,0.6]
var currentIndex = -3
var listOfSongs = []
var chartList = []

	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("redHeart"):
		RH.emit()
		return
	if Input.is_action_just_pressed("yellowCircle"):
		YC.emit()
		return
	if Input.is_action_just_pressed("greenDiamond"):
		GD.emit()
		return
	if Input.is_action_just_pressed("blueTriangle"):
		BT.emit()
		return
	
func _on_create_pressed() -> void:
	changeScreen(1)

func changeScreen(screen: int):
	currentScreen = screen
	$Camera2D.global_position = get_node(screens[currentScreen]).global_position + Vector2(800,500)
