extends VBoxContainer

const playlists_menu = preload("res://scenes/playlists_menu.tscn")
const about_screen = preload("res://scenes/about_screen.tscn")


func _on_playlists_menu_item_pressed() -> void:
	var screen: VBoxContainer = playlists_menu.instantiate()
	Signals.screen_pushed.emit("Playlists", screen)


func _on_about_menu_item_pressed() -> void:
	var screen: Label = about_screen.instantiate()
	Signals.screen_pushed.emit("About", screen)
