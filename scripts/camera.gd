extends Camera2D

@onready var bea: Bea = %Bea


func _process(_delta: float) -> void:
	global_position = bea.current_room.get_closest_point_on_path(bea.global_position)
