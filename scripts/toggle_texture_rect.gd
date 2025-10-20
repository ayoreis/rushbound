@tool
extends TextureRect

@export var sprite_frames: SpriteFrames:
	set(value):
		sprite_frames = value

		if sprite_frames != null:
			sprite_frames.connect("changed", _update_texture)
		else:
			texture = null

@export var toggle: bool:
	set(value):
		toggle = value

		if sprite_frames != null:
			_update_texture()


func _update_texture() -> void:
	texture = sprite_frames.get_frame_texture("default", toggle)
