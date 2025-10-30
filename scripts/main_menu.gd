extends VBoxContainer

const PLAYLISTS_MENU = preload("res://scenes/playlists_menu.tscn")
const TUTORIAL_SCREEN = preload("res://scenes/tutorial_screen.tscn")
const ABOUT_SCREEN = preload("res://scenes/about_screen.tscn")


func _on_playlists_menu_item_pressed() -> void:
	var screen: VBoxContainer = PLAYLISTS_MENU.instantiate()
	Signals.screen_pushed.emit("Playlists", screen)


func _on_tutorial_menu_item_pressed() -> void:
	var screen: Label = TUTORIAL_SCREEN.instantiate()
	Signals.screen_pushed.emit("Tutorial", screen)


func _on_about_menu_item_pressed() -> void:
	var screen: Label = ABOUT_SCREEN.instantiate()
	Signals.screen_pushed.emit("About", screen)
