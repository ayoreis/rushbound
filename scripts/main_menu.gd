extends Control

const playlists := preload("res://scenes/ipod/playlists.tscn")

@onready var first_button := $ScrollContainer/MarginContainer/VBoxContainer.get_child(0) as Button


func _ready() -> void:
	first_button.grab_focus()


func _on_playlist_button_pressed() -> void:
	get_parent().add_child(playlists.instantiate())
	queue_free()
