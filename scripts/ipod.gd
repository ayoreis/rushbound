class_name iPod
extends TextureRect

@export var playlists: Array[Playlist]

var screen_stack: Array[Dictionary] = []

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
	grab_focus_child()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("menu") and screen_stack.size() > 0:
		pop_screen()

	if Input.is_action_just_pressed("scroll_wheel"):
		scroll_timer.start()

	menu_button.toggle = Input.is_action_pressed("menu")
	next_fast_forward.toggle = Input.is_action_pressed("next_fast_forward")
	play_pause.toggle = Input.is_action_pressed("play_pause")
	previous_rewind.toggle = Input.is_action_pressed("previous_rewind")
	scroll_wheel.toggle = not scroll_timer.is_stopped()
	select_button.toggle = Input.is_action_pressed("select")


func push_screen(title: String, node: Node) -> void:
	var previous := scroll_container.get_child(0)
	scroll_container.remove_child(previous)
	screen_stack.push_front({ title = title, node = previous })
	_update_screen(title, node)


func pop_screen() -> void:
	scroll_container.get_child(0).queue_free()
	var screen: Dictionary = screen_stack.pop_front()
	var title: String = screen.title
	var node: Node = screen.node
	_update_screen(title, node)


func _update_screen(title: String, node: Node) -> void:
	label.text = title
	scroll_container.add_child(node)
	grab_focus_child()


func grab_focus_child(node: Node = self) -> void:
	for child in node.get_children():
		if child is Control:
			var control: Control = child

			if control.focus_mode != FOCUS_NONE:
				control.grab_focus()
				return

		grab_focus_child(child)
