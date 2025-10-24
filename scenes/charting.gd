extends Node

var inputs = ["redHeart","yellowCircle","greenDiamond","blueTriangle"]

var currentScreen = 2
var screens = ["EditCreate", "ChartList"] 
var yPosList = [195,295,425,585,715]
var scaleList = [0.6,0.8,1,0.8,0.6]
var currentIndex = -3
var listOfSongs = []
var chartList = []

func _ready() -> void:
	#Of main menu
	
	#Of Song list menu
	var dir := DirAccess.open("res://charts")
	if dir:
		dir.list_dir_begin()
		var file_name: String = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				# Construct the full path to the resource
				var file_path: String = "res://charts" + "/" + file_name
				# Load the resource if it's a recognized resource type
				if ResourceLoader.exists(file_path):
					var resource = load(file_path)
					if resource:
						listOfSongs.append(resource)
				file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("Could not open directory: " + "res://charts")
	
	for i in listOfSongs:
		print(i.name)
		var newChart = $ChartList/Chart.duplicate()
		chartList.append(newChart)
		newChart.get_node("Album").texture = i.albumCover
		newChart.get_node("Name").text = i.name
		newChart.visible = true
		$ChartList.add_child(newChart)
		
	updateChartList(true)
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("redHeart"):
		updateChartList(true)
		
	if Input.is_action_just_pressed("yellowCircle"):
		updateChartList(false)
	
	
func _on_create_pressed() -> void:
	changeScreen(1)

func changeScreen(screen: int):
	currentScreen = screen
	$Camera2D.global_position = get_node(screens[currentScreen]).global_position + Vector2(800,500)

func _on_edit_pressed() -> void:
	var newSong = $ChartList/Song.duplicate()
	$ChartList.add_child(newSong)
	newSong.global_position += Vector2(0,150)
	newSong.get_node("Background").color = Color((float(randi_range(0,100))/100),(float(randi_range(0,100))/100),(float(randi_range(0,100))/100))

func _on_top_button_pressed() -> void:
	updateChartList(true)

func _on_bottom_button_pressed() -> void:
	updateChartList(false)
	
func updateChartList(up: bool):
	if (currentIndex==-2 and !up) or (currentIndex==chartList.size()-3 and up):
		return
	
	
	currentIndex += 1 if up else -1
	$ChartList/Label.text = str(currentIndex)
	
	for i in chartList.size():
		if i >= currentIndex and i <= currentIndex + 4:
			var offset = i - currentIndex
			chartList[i].visible = true
			chartList[i].position = Vector2(300, yPosList[offset])
			chartList[i].scale = Vector2(scaleList[offset], scaleList[offset])
		else:
			chartList[i].visible = false
