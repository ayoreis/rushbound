extends SubViewportContainer

@onready var sub_viewport: SubViewport = $SubViewport


func _ready() -> void:
	Signals.track_played.connect(_on_track_played)


func _on_track_played(track: Track) -> void:
	sub_viewport.get_child(0).queue_free()
	var scene: PackedScene = load(track.scene)
	sub_viewport.add_child(scene.instantiate())
