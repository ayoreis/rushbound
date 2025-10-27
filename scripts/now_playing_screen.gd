class_name NowPlayingScreen
extends VBoxContainer

var track: Track

@onready var stream: AudioStreamMP3 = load(track.stream)
@onready var title_label: Label = $TitleLabel
@onready var artist_label: Label = $ArtistLabel
@onready var album_label: Label = $AlbumLabel
@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar
@onready var elapsed_time_label: Label = %ElapsedTimeLabel
@onready var remaining_time_label: Label = %RemainingTimeLabel


func _ready() -> void:
	title_label.text = track.title 
	artist_label.text = track.artist
	album_label.text = track.album

	var _on_process_frame := func () -> void:
		texture_progress_bar.max_value = texture_progress_bar.size.x

	get_tree().process_frame.connect(_on_process_frame, CONNECT_ONE_SHOT)

	Signals.playback_position_changed.connect(_on_playback_position_changed)
	Signals.track_selected.emit(track)


func _on_playback_position_changed(playback_position: float) -> void:
	var elapsed_time := floori(playback_position)
	var stream_length := stream.get_length()
	var remaining_time := elapsed_time - stream_length
	var playback_progress := elapsed_time / stream_length
	texture_progress_bar.value = (texture_progress_bar.max_value - 2) * playback_progress + 1
	elapsed_time_label.text = _format_duration(elapsed_time)
	remaining_time_label.text = _format_duration(remaining_time)


func _format_duration(duration: float) -> String:
	var minutes := duration / 60
	var seconds := int(duration) % 60
	return "%.0f:%02d" % [minutes, abs(seconds)]
