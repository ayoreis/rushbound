class_name Pocket
extends CanvasLayer

const ANIMATION_NAME = "toggle"

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var ipod: iPod = %iPod


func _ready() -> void:
	get_tree().paused = true


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("toggle_pocket") && not animation_player.is_playing():
		# Put in
		if get_tree().paused:
			animation_player.play(ANIMATION_NAME)
		# Take out
		else:
			animation_player.play_backwards(ANIMATION_NAME)


func _on_animation_player_animation_started(_animation_name: StringName) -> void:
	get_tree().paused = true


func _on_animation_player_animation_finished(_animation_name: StringName) -> void:
	get_tree().paused = animation_player.current_animation_position != animation_player.current_animation_length
