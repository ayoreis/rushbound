@tool
class_name Room
extends Area2D

enum Diagonal {
	ASCENDING,
	DESCENDING,
}

var _width: int = ProjectSettings.get_setting("display/window/size/viewport_width")
var _height: int = ProjectSettings.get_setting("display/window/size/viewport_height")
var _viewport_size := Vector2i(_width, _height)

@export var size := _viewport_size:
	set(new_size):
		if not is_node_ready():
			await ready

		size = new_size
		_rectangle_shape.size = size
		_update_path()
		queue_redraw()

@export var diagonal: Diagonal:
	set(new_diagonal):
		if not is_node_ready():
			await ready

		diagonal = new_diagonal
		_update_path()
		queue_redraw()

var _path_from: Vector2
var _path_to: Vector2

@onready var _collision_shape: CollisionShape2D = $CollisionShape2D
@onready var _rectangle_shape: RectangleShape2D = _collision_shape.shape


func _draw() -> void:
	if not Engine.is_editor_hint():
		return

	draw_line(_path_from, _path_to, Color.WHITE)


func get_closest_point_on_path(to_point: Vector2) -> Vector2:
	var from := to_global(_path_from)
	var to := to_global(_path_to)

	var clamped_x := clampf(to_point.x, minf(from.x, to.x), maxf(from.x, to.x))
	var clamped_y := clampf(to_point.y, minf(from.y, to.y), maxf(from.y, to.y))

	if from.x == to.x:
		return Vector2(from.x, clamped_y)

	if from.y == to.y:
		return Vector2(clamped_x, from.y)

	var m := (to.y - from.y) / (to.x - from.x)

	if abs(m) > 1:
		var x := m * clamped_y 
		return Vector2(x, clamped_y)
	else:
		var y := m * clamped_x
		return Vector2(clamped_x, y)


func _update_path() -> void:
	var corner := (size as Vector2i - _viewport_size) / 2

	match diagonal:
		Diagonal.ASCENDING:
			_path_from = corner * Vector2i(-1, 1)
			_path_to = corner * Vector2i(1, -1)

		Diagonal.DESCENDING:
			_path_from = corner * -1
			_path_to = corner
