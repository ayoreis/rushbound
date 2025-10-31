extends Camera2D

@onready var player: Player = %Player


func _process(_delta: float) -> void:
	global_position = player.current_room.get_closest_point_on_path(player.global_position)
