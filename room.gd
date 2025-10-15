@tool
class_name Room
extends Area2D

var width: int = ProjectSettings.get_setting("display/window/size/viewport_width")
var height: int = ProjectSettings.get_setting("display/window/size/viewport_height")

@export var room_size := Vector2i(width, height):
	set(size):
		if !is_node_ready():
			await ready

		room_size = size
		rectangle_shape.size = room_size

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var rectangle_shape: RectangleShape2D = collision_shape.shape


func get_closest_point(to_point: Vector2) -> Vector2:
	var closest_point := func (path: Path2D) -> Vector2:
		return path.to_global(path.curve.get_closest_point(path.to_local(to_point)))

	var closer_point := func (a: Vector2, b: Vector2) -> Vector2:
		return a if a.distance_to(to_point) < b.distance_to(to_point) else b

	var paths := find_children("*", "Path2D")

	return (paths
			.map(closest_point)
			.reduce(closer_point))
