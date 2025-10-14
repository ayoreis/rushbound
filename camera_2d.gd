extends Camera2D

const ROOMS: Array[Vector2] = [Vector2(160, 90), Vector2(480, 90)]
const SPEED = 500

@onready var player: CharacterBody2D = $"../CharacterBody2D"


func _process(delta: float) -> void:
	var closest: Vector2 = ROOMS.reduce(closest_to_player)
	position = position.move_toward(closest, SPEED * delta)


func closest_to_player(a: Vector2, b: Vector2) -> Vector2:
	return a if a.distance_to(player.position) < b.distance_to(player.position) else b
