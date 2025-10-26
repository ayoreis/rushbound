extends Button

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _on_focus_exited() -> void:
	if audio_stream_player.is_inside_tree():
		audio_stream_player.play()
