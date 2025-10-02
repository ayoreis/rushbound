extends CanvasLayer

const TIMING_WINDOW := 0.15

@onready var player := $"../AudioStreamPlayer" as AudioStreamPlayer
@onready var label := $CenterContainer/Label as Label


func _process(_delta: float) -> void:
	var time := player.get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency()
	var stream := player.stream as AudioStreamMP3
	var beat_duration := 60 / stream.bpm
	var closest_beat := floorf(time / beat_duration) * beat_duration

	if Input.is_action_just_pressed("beat"):
		label.text = "%s beat" % ("On" if abs(time - closest_beat) < TIMING_WINDOW else "Off")
