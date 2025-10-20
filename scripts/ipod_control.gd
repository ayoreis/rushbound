@tool
class_name iPodControl
extends TextureRect

@export var sprite_frames: SpriteFrames

@export var press_stream: AudioStream:
	set(stream):
		press_stream = stream

		if not is_node_ready():
			await ready

		press_audio_stream_player.stream = press_stream

@export var release_stream: AudioStream:
	set(stream):
		release_stream = stream

		if not is_node_ready():
			await ready

		release_audio_stream_player.stream = release_stream

var toggle: bool:
	set(value):
		if value == toggle:
			return

		toggle = value

		_update_texture()

		if toggle:
			press_audio_stream_player.play()
		else:
			release_audio_stream_player.play()

@onready var press_audio_stream_player: AudioStreamPlayer = $PressAudioStreamPlayer
@onready var release_audio_stream_player: AudioStreamPlayer = $ReleaseAudioStreamPlayer


func _ready() -> void:
	sprite_frames.connect("changed", _update_texture)


func _update_texture() -> void:
	texture = sprite_frames.get_frame_texture("default", toggle)
