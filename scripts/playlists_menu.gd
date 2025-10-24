class_name PlaylistsMenu
extends VBoxContainer

const menu_item = preload("res://scenes/menu_item.tscn")
const playlist_menu = preload("res://scenes/playlist_menu.tscn")

@export var playlists: Array[Playlist]

@onready var ipod: iPod = $"../../%iPod"


func _ready() -> void:
	for playlist in playlists:
		var item: Button = menu_item.instantiate()
		item.text = playlist.title

		var _on_menu_item_pressed := func () -> void:
			var menu: PlaylistMenu = playlist_menu.instantiate()
			menu.playlist = playlist
			ipod.push_screen(playlist.title, menu)

		item.connect("pressed", _on_menu_item_pressed)
		add_child(item)
