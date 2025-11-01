extends CanvasLayer

const ANIMATION_NAME = &"draw"

@onready var _animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	Signals.draw.connect(_on_draw)
	Signals.draw.emit()


func _on_draw() -> void:
		if not get_tree().paused:
			_animation_player.play(ANIMATION_NAME)
		else:
			_animation_player.play_backwards(ANIMATION_NAME)


func _on_animation_player_animation_started(_animation_name: StringName) -> void:
	get_tree().paused = true


func _on_animation_player_animation_finished(_animation_name: StringName) -> void:
	get_tree().paused = _animation_player.current_animation_position == _animation_player.current_animation_length
