extends Camera2D

var camera: Camera2D


func _process(_delta: float) -> void:
	if camera == null:
		return

	var camera_position := camera.get_screen_center_position()
	offset = camera_position - camera_position.round()


func _on_sub_viewport_child_entered_tree(node: Node2D) -> void:
	await node.ready
	camera = node.get_node_or_null("Camera2D")
