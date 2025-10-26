extends VBoxContainer

const menu_item = preload("res://scenes/menu_item.tscn")
const playlist_menu = preload("res://scenes/playlist_menu.tscn")

@export var playlists: Array[Playlist]


func _ready() -> void:
	for playlist in playlists:
		var item: Button = menu_item.instantiate()
		item.text = playlist.title

		var _on_menu_item_pressed := func () -> void:
			var screen: PlaylistMenu = playlist_menu.instantiate()
			screen.playlist = playlist
			Signals.screen_pushed.emit(playlist.title, screen)

		item.pressed.connect(_on_menu_item_pressed)
		add_child(item)
