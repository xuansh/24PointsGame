extends Block

@export var value : float

@onready var num_rich_text_label: RichTextLabel = $NumRichTextLabel

func _ready() -> void:
	if get_value() == int(get_value()):
		num_rich_text_label.text = str(int(get_value()))
	else:
		num_rich_text_label.text = str(get_value())

func _process(delta: float) -> void:
	if is_dragging:
		global_position = lerp(global_position, get_global_mouse_position(), 20 * delta)

func get_value() -> float:
	return value


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			if event.pressed and GAMEMANAGER.current_dragging == null:
				is_dragging = true
				GAMEMANAGER.current_dragging = self
				GAMEMANAGER.bring_to_front()
				print("numberBlock")
			else:
				is_dragging = false	
				if GAMEMANAGER.current_dragging == self:
					GAMEMANAGER.current_dragging = null
