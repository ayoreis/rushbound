extends Camera2D

@onready var camera: Camera2D = $"../SubViewportContainer/SubViewport/Node2D/Camera2D"


func _process(_delta: float) -> void:
	var camera_position := camera.get_screen_center_position()
	offset = camera_position - camera_position.round()
