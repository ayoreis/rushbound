@tool
class_name Room
extends Area2D

enum Diagonal {
	ASCENDING,
	DESCENDING,
}

var width: int = ProjectSettings.get_setting("display/window/size/viewport_width")
var height: int = ProjectSettings.get_setting("display/window/size/viewport_height")
var viewport_size := Vector2i(width, height)

@export var size := viewport_size:
	set(new_size):
		if !is_node_ready():
			await ready

		size = new_size.max(viewport_size)
		_rectangle_shape.size = size
		_update_curve()

@export var diagonal: Diagonal:
	set(new_diagonal):
		if !is_node_ready():
			await ready

		diagonal = new_diagonal
		_update_curve()

@onready var _collision_shape: CollisionShape2D = $CollisionShape2D
@onready var _rectangle_shape: RectangleShape2D = _collision_shape.shape
@onready var _path: Path2D = $Path2D
@onready var _curve := _path.curve


func get_closest_point(to_point: Vector2) -> Vector2:
	return _path.to_global(_curve.get_closest_point(_path.to_local(to_point)))


func _update_curve() -> void:
	match diagonal:
		Diagonal.ASCENDING:
			_curve.set_point_position(0, (size - viewport_size) / Vector2i(-2, 2))
			_curve.set_point_position(1, (size - viewport_size) / Vector2i(2, -2))

		Diagonal.DESCENDING:
			_curve.set_point_position(0, (size - viewport_size) / -2)
			_curve.set_point_position(1, (size - viewport_size) / 2)
