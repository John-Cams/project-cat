extends Sprite2D

func _ready():
	for child in get_children():
		if child is Area2D:
			child.connect("body_entered", Callable(self, "_on_area_entered").bind(child))

func _on_area_entered(body: Node, area: Area2D):
	print(area.name, "was entered by", body.name)
