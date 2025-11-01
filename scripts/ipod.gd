class_name iPod
extends TextureRect

const MAIN_MENU = preload("res://scenes/main_menu.tscn")
const TUTORIAL_SCREEN = preload("res://scenes/tutorial_screen.tscn")

var _main_menu: VBoxContainer = MAIN_MENU.instantiate()
var screen_stack: Array[Dictionary] = [{ title = "Rushbound", node = _main_menu }]
var playback_position: float

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var scroll_timer: Timer = %ScrollTimer
@onready var menu_button: iPodControl = %MenuButton
@onready var next_fast_forward: iPodControl = %NextFastForward
@onready var play_pause: iPodControl = %PlayPause
@onready var previous_rewind: iPodControl = %PreviousRewind
@onready var scroll_wheel: iPodControl = %ScrollWheel
@onready var select_button: iPodControl = %SelectButton
@onready var label: Label = $GUI/VBoxContainer/Label
@onready var scroll_container: ScrollContainer = $GUI/VBoxContainer/ScrollContainer
@onready var animation_player: AnimationPlayer = $GUI/VBoxContainer/ScrollContainer/AnimationPlayer
@onready var h_box_container: HBoxContainer = $GUI/VBoxContainer/ScrollContainer/HBoxContainer


func _ready() -> void:
	Signals.screen_pushed.connect(_on_screen_pushed)
	Signals.track_selected.connect(_on_track_selected)

	var screen: Control = h_box_container.get_child(0)
	var valid_focus_child := find_valid_focus_child(screen)

	if valid_focus_child != null:
		valid_focus_child.grab_focus()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("menu"):
		position.y -= 1

		if screen_stack.size() > 0:
			var focus_owner := get_viewport().gui_get_focus_owner()

			if focus_owner != null:
				release_focus()
				focus_owner.theme_type_variation = &"ButtonFocused"

			var screen: Dictionary = screen_stack.pop_front()
			var title: String = screen.title
			var node: Control = screen.node
			print(screen)

			label.text = title
			h_box_container.custom_minimum_size.x = h_box_container.size.x * 2
			h_box_container.add_child(node)
			h_box_container.move_child(node, 0)

			var focus_child := find_valid_focus_child(node)

			if focus_child != null:
				focus_child.theme_type_variation = &"ButtonFocused"

			var _on_animation_finished := func (_animation_name: StringName) -> void:
				h_box_container.get_child(1).queue_free()
				h_box_container.custom_minimum_size.x = 0

				if focus_child != null:
					focus_child.theme_type_variation = &""
					focus_child.call_deferred("grab_focus")

			animation_player.animation_finished.connect(_on_animation_finished, CONNECT_ONE_SHOT)
			animation_player.play_backwards("push")

	if Input.is_action_just_released("menu"):
		position.y += 1

	if Input.is_action_just_pressed("next_fast_forward"):
		position.x += 1

	if Input.is_action_just_released("next_fast_forward"):
		position.x -= 1

	if audio_stream_player.playing:
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


func _on_screen_pushed(title: String, node: Control) -> void:
	var focus_owner := get_viewport().gui_get_focus_owner()

	if focus_owner != null:
		release_focus()
		focus_owner.theme_type_variation = &"ButtonFocused"

	var previous_title := label.text

	label.text = title
	h_box_container.custom_minimum_size.x = h_box_container.size.x * 2
	h_box_container.add_child(node)

	var focus_child := find_valid_focus_child(node)

	if focus_child != null:
		focus_child.theme_type_variation = &"ButtonFocused"

	animation_player.play("push")
	await animation_player.animation_finished
	
	if focus_owner != null:
		focus_owner.theme_type_variation = &""

	if focus_child != null:
		focus_child.theme_type_variation = &""
		focus_child.grab_focus()

	var previous_screen := h_box_container.get_child(0)
	screen_stack.push_front({ title = previous_title, node = previous_screen })
	h_box_container.remove_child(previous_screen)
	h_box_container.custom_minimum_size.x = 0


func _on_track_selected(track: Track) -> void:
	var stream: AudioStreamMP3 = load(track.stream)

	if stream != audio_stream_player.stream:
		audio_stream_player.stream = stream
		audio_stream_player.play()


func find_valid_focus_child(control: Control) -> Control:
	for child in control.get_children():
		if child is not Control:
			continue

		var focus_child: Control = child

		if focus_child.focus_mode != FOCUS_NONE:
			return focus_child
			
		var valid_focus_child := find_valid_focus_child(focus_child)

		if valid_focus_child != null:
			return valid_focus_child

	return null
