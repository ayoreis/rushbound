extends VBoxContainer

const playlists_menu = preload("res://scenes/playlists_menu.tscn")

@onready var ipod: iPod = $"../../%iPod"


func _on_playlists_menu_item_pressed() -> void:
	var menu: PlaylistsMenu = playlists_menu.instantiate()
	menu.playlists = ipod.playlists
	ipod.push_screen("Playlists", menu)
