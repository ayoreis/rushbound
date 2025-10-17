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
	var a := to_global(_curve.get_point_position(0))
	var b := to_global(_curve.get_point_position(1))

	var clamped_x := clampf(to_point.x, minf(a.x, b.x), maxf(a.x, b.x))
	var clamped_y := clampf(to_point.y, minf(a.y, b.y), maxf(a.y, b.y))

	if a.x == b.x:
		return Vector2(a.x, clamped_y)

	if a.y == b.y:
		return Vector2(clamped_x, a.y)

	var m := (b.y - a.y) / (b.x - a.x)

	if abs(m) > 1:
		var x := m * clamped_y + (a.x - m * a.y)
		return Vector2(x, clamped_y)
	else:
		var y := m * clamped_x + (a.y - m * a.x)
		return Vector2(clamped_x, y)


func _update_curve() -> void:
	match diagonal:
		Diagonal.ASCENDING:
			_curve.set_point_position(0, (size - viewport_size) / Vector2i(-2, 2))
			_curve.set_point_position(1, (size - viewport_size) / Vector2i(2, -2))

		Diagonal.DESCENDING:
			_curve.set_point_position(0, (size - viewport_size) / -2)
			_curve.set_point_position(1, (size - viewport_size) / 2)
