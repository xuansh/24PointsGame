extends Camera2D

var zoom_speed : float = 0.05
var speed : float = 1
var margin : int = 10

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
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			self.zoom = lerp(self.zoom, self.zoom + Vector2(zoom_speed, zoom_speed), 0.5)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			self.zoom = lerp(self.zoom, self.zoom - Vector2(zoom_speed, zoom_speed), 0.5)
