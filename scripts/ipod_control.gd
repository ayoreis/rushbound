@tool
class_name iPodControl
extends TextureRect

@export var action: StringName
@export var sprite_frames: SpriteFrames

@export var press_stream: AudioStream:
	set(stream):
		if not is_node_ready():
			await ready

		press_stream = stream
		press_audio_stream_player.stream = press_stream

@export var release_stream: AudioStream:
	set(stream):
		if not is_node_ready():
			await ready

		release_stream = stream
		release_audio_stream_player.stream = release_stream

var _pressed: bool

@onready var press_audio_stream_player: AudioStreamPlayer = $PressAudioStreamPlayer
@onready var release_audio_stream_player: AudioStreamPlayer = $ReleaseAudioStreamPlayer


func _ready() -> void:
	sprite_frames.changed.connect(_update_texture)


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return

	if action != &"":
		if Input.is_action_just_pressed(action):
			press()

		if Input.is_action_just_released(action):
			release()


func press() -> void:
	_pressed = true
	_update_texture()
	press_audio_stream_player.play()


func release() -> void:
	_pressed = false
	_update_texture()
	release_audio_stream_player.play()


func _update_texture() -> void:
	texture = sprite_frames.get_frame_texture("default", _pressed)
