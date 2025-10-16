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
		if !Engine.is_editor_hint():
			return

		if !is_node_ready():
			await ready

		size = new_size.max(viewport_size)
		_rectangle_shape.size = size
		_update_curve()

@export var diagonal: Diagonal:
	set(new_diagonal):
		if !Engine.is_editor_hint():
			return

		if !is_node_ready():
			await ready

		diagonal = new_diagonal
		_update_curve()

@export var entrance: Room:
	set(room):
		if !Engine.is_editor_hint():
			return

		if !is_node_ready():
			await ready

		# NOTE Prevent infinite loop
		if room == entrance:
			return

		if room != null:
			entrance = room
			entrance.exit = self
		elif entrance != null:
			entrance.exit = null
			entrance = null

		_update_curve()

@export var exit: Room:
	set(room):
		if !Engine.is_editor_hint():
			return

		if !is_node_ready():
			await ready

		# NOTE Prevent infinite loop
		if room == exit:
			return

		if room != null:
			exit = room
			exit.entrance = self
		elif exit != null:
			exit.entrance = null
			exit = null

		_update_curve()

@onready var _collision_shape: CollisionShape2D = $CollisionShape2D
@onready var _rectangle_shape: RectangleShape2D = _collision_shape.shape
@onready var _path: Path2D = $Path2D
@onready var _curve := _path.curve


func _ready() -> void:
	set_notify_transform(Engine.is_editor_hint()) 


func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		_update_curve()

		if entrance != null:
			entrance._update_curve()

		if exit != null:
			exit._update_curve()


func get_closest_point(to_point: Vector2) -> Vector2:
	return _path.to_global(_curve.get_closest_point(_path.to_local(to_point)))


func _update_curve() -> void:
	# INFO Curve2D.get_closest_point fails when points overlap
	if size == viewport_size && entrance == null && exit == null:
		if _curve.point_count == 2:
			_curve.remove_point(1)

		return

	if _curve.point_count == 1:
		_curve.add_point(Vector2.ZERO)

	if entrance != null:
		var ratio_vector := (size / -2.0 / to_local(entrance.global_position)).abs()
		var ratio := absf(minf(ratio_vector.x, ratio_vector.y))
		_curve.set_point_position(0, to_local(entrance.global_position) * ratio)
	else:
		match diagonal:
			Diagonal.ASCENDING:
				_curve.set_point_position(0, (size - viewport_size) / Vector2i(-2, 2))

			Diagonal.DESCENDING:
				_curve.set_point_position(0, (size - viewport_size) / -2)

	if exit != null:
		var ratio_vector := (size / 2.0 / to_local(exit.global_position)).abs()
		var ratio := minf(ratio_vector.x, ratio_vector.y)
		_curve.set_point_position(1, to_local(exit.global_position) * ratio)
	else:
		match diagonal:
			Diagonal.ASCENDING:
				_curve.set_point_position(1, (size - viewport_size) / Vector2i(2, -2))
			Diagonal.DESCENDING:
				_curve.set_point_position(1, (size - viewport_size) / 2)
