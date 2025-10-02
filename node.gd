extends Node

var playback_position := 0.0

@onready var animation_player := $AnimationPlayer as AnimationPlayer
@onready var audio_stream_player := $AudioStreamPlayer as AudioStreamPlayer


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel") and not animation_player.is_playing():
		if animation_player.current_animation_position == 0:
			playback_position = audio_stream_player.get_playback_position()
			audio_stream_player.stop()
			animation_player.play("new_animation")
		else:
			audio_stream_player.play(playback_position)
			animation_player.play_backwards("new_animation")
