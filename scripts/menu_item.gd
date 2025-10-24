extends Button

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _on_focus_entered() -> void:
	audio_stream_player.play()
