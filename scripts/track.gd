extends Node2D

const PLAYER = preload("res://scenes/player.tscn")

@export var initial_room: Room

var player: Player = PLAYER.instantiate()
var camera := Camera2D.new()


func _ready() -> void:
	var checkpoint: Marker2D = initial_room.get_node(^"Marker2D")
	player.current_room = initial_room
	player.global_position = checkpoint.global_position

	for room: Room in find_children("*", "Room"):
		room.body_entered.connect(player._on_room_body_entered.bind(room))

	add_child(player)
	
	camera.position_smoothing_enabled = true
	_position_camera()
	add_child(camera)


func _process(_delta: float) -> void:
	_position_camera()


func _position_camera() -> void:
	camera.global_position = player.current_room.get_closest_point_on_path(player.global_position)
