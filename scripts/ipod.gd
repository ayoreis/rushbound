class_name iPod
extends TextureRect

var screen_stack: Array[Dictionary] = []
var playback_position: float

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var scroll_timer: Timer = %ScrollTimer
@onready var menu_button: iPodControl = %MenuButton
@onready var next_fast_forward: iPodControl = %NextFastForward
@onready var play_pause: iPodControl = %PlayPause
@onready var previous_rewind: iPodControl = %PreviousRewind
@onready var scroll_wheel: iPodControl = %ScrollWheel
@onready var select_button: iPodControl = %SelectButton
@onready var label: Label = $GUI/Label
@onready var scroll_container: ScrollContainer = $GUI/ScrollContainer


func _ready() -> void:
	Signals.screen_pushed.connect(_on_screen_pushed)
	Signals.track_selected.connect(_on_track_selected)
	grab_focus_child()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("menu"):
		if screen_stack.size() > 0:
			scroll_container.get_child(0).queue_free()
			var screen: Dictionary = screen_stack.pop_front()
			var title: String = screen.title
			var node: Node = screen.node
			_update_screen(title, node)

		position.y -= 1

	if Input.is_action_just_released("menu"):
		position.y += 1

	if Input.is_action_just_pressed("next_fast_forward"):
		position.x += 1

	if Input.is_action_just_released("next_fast_forward"):
		position.x -= 1

	playback_position = audio_stream_player.get_playback_position()

	if Input.is_action_just_pressed("play_pause"):
		if audio_stream_player.playing:
			audio_stream_player.stop()
		else:
			audio_stream_player.play(playback_position)

		position.y += 1

	if Input.is_action_just_released("play_pause"):
		position.y -= 1

	if Input.is_action_just_pressed("previous_rewind"):
		position.x -= 1

	if Input.is_action_just_released("previous_rewind"):
		position.x += 1

	if Input.is_action_just_pressed("scroll_wheel"):
		scroll_wheel.press()
		scroll_timer.start()

	if scroll_timer.is_stopped():
		scroll_wheel.release()

	if audio_stream_player.playing:
		Signals.playback_position_changed.emit(playback_position)


func _input(event: InputEvent) -> void:
	if event.is_action("scroll_wheel_clockwise"):
		var event2 := InputEventKey.new()
		event2.pressed = event.is_pressed()
		event2.physical_keycode = KEY_F34
		Input.parse_input_event(event2)

	if event.is_action("scroll_wheel_counter_clockwise"):
		var event2 := InputEventKey.new()
		event2.pressed = event.is_pressed()
		event2.physical_keycode = KEY_F35
		Input.parse_input_event(event2)


func _on_screen_pushed(title: String, node: Node) -> void:
	var previous_node := scroll_container.get_child(0)
	scroll_container.remove_child(previous_node)
	screen_stack.push_front({ title = label.text, node = previous_node })
	_update_screen(title, node)


func _on_track_selected(track: Track) -> void:
	var stream: AudioStreamMP3 = load(track.stream)

	if stream != audio_stream_player.stream:
		audio_stream_player.stream = stream
		audio_stream_player.play()


func grab_focus_child(node: Node = self) -> void:
	for child in node.get_children():
		if child is Control:
			var control: Control = child

			if control.focus_mode != FOCUS_NONE:
				control.grab_focus()
				return

		grab_focus_child(child)


func _update_screen(title: String, node: Node) -> void:
	label.text = title
	scroll_container.add_child(node)
	grab_focus_child()
