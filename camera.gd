extends Camera2D

const SPEED = 500

@export var current_room: Room

@onready var player: CharacterBody2D = %Player


func _process(_delta: float) -> void:
	global_position = current_room.get_closest_point(player.global_position)


func _on_room_body_entered(body: Node2D, room: Room) -> void:
	if body != player:
		return

	current_room = room
