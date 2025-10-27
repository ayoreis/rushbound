extends Node

@warning_ignore_start("unused_signal")
signal screen_pushed(title: String, screen: Node)
signal track_selected(track: Track)
signal playback_position_changed(playback_position: int)
@warning_ignore_restore("unused_signal")
