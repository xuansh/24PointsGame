extends Camera2D

var zoom_speed : float = 0.05
var speed : float = 1
var margin : int = 10
var min_zoom : float = 0.5
var max_zoom : float = 1.5

func _ready() -> void:
	GAMEMANAGER.MainCamera = self
#
func _process(delta: float) -> void:
	var pos = get_viewport().get_mouse_position()
	if pos.x < margin:
		self.position.x -= speed * self.zoom.x
	if pos.x > get_viewport_rect().size.x - margin:
		self.position.x += speed * self.zoom.x
	if pos.y < margin:
		self.position.y -= speed * self.zoom.x
	if pos.y > get_viewport_rect().size.y - margin:
		self.position.y += speed * self.zoom.x


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var target_zoom = self.zoom
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			target_zoom = self.zoom + Vector2(zoom_speed, zoom_speed)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			target_zoom = self.zoom - Vector2(zoom_speed, zoom_speed)
		target_zoom.x = clamp(target_zoom.x, min_zoom, max_zoom)
		target_zoom.y = clamp(target_zoom.y, min_zoom, max_zoom)
		self.zoom = lerp(self.zoom, target_zoom, 0.5)
