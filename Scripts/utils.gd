extends Spatial

static func get_cursor_world_position(viewport: Viewport, camera: Camera):
	var cursor_position = viewport.get_mouse_position()
	return camera.project_position(cursor_position, camera.translation.y)
