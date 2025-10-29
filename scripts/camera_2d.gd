extends Camera2D

func _ready() -> void:
	CamControl.camera = self
	CamControl.rect = $ColorRect
