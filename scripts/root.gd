extends Node

@onready var scroll_timer: Timer = %ScrollTimer
@onready var menu_button: iPodControl = %MenuButton
@onready var next_fast_forward: iPodControl = %NextFastForward
@onready var play_pause: iPodControl = %PlayPause
@onready var previous_rewind: iPodControl = %PreviousRewind
@onready var scroll_wheel: iPodControl = %ScrollWheel
@onready var select_button: iPodControl = %SelectButton


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("scroll_wheel"):
		scroll_timer.start()

	menu_button.toggle = Input.is_action_pressed("menu")
	next_fast_forward.toggle = Input.is_action_pressed("next_fast_forward")
	play_pause.toggle = Input.is_action_pressed("play_pause")
	previous_rewind.toggle = Input.is_action_pressed("previous_rewind")
	scroll_wheel.toggle = not scroll_timer.is_stopped()
	select_button.toggle = Input.is_action_pressed("select")
