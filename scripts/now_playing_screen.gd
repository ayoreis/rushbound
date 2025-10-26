class_name NowPlayingScreen
extends VBoxContainer

var track: Track

@onready var title_label: Label = $TitleLabel
@onready var artist_label: Label = $ArtistLabel
@onready var album_label: Label = $AlbumLabel


func _ready() -> void:
	title_label.text = track.title
	artist_label.text = track.artist
	album_label.text = track.album
	Signals.track_selected.emit(track)
