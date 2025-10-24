class_name Track
extends Resource

@export var title: String
@export var artist: String
@export var album: String
@export_file("*.mp3") var stream: String
@export_file("*.tscn") var scene: String
