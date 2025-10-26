class_name PlaylistMenu
extends VBoxContainer

const menu_item = preload("res://scenes/menu_item.tscn")
const now_playing_screen = preload("res://scenes/now_playing_screen.tscn")

var playlist: Playlist


func _ready() -> void:
	for track in playlist.tracks:
		var item: Button = menu_item.instantiate()
		item.text = track.title

		var _on_menu_item_pressed := func () -> void:
			var screen: NowPlayingScreen = now_playing_screen.instantiate()
			screen.track = track
			Signals.screen_pushed.emit("Now Playing", screen)

		item.pressed.connect(_on_menu_item_pressed)
		add_child(item)
