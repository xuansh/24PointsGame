extends Block

class_name NumberBlock

@export var root : Node2D = null
@export var value : float

@onready var num_rich_text_label: RichTextLabel = $NumRichTextLabel


# only on Debug
func _ready() -> void:
	update_value_label()

func _process(delta: float) -> void:
	if is_dragging:
		global_position = lerp(global_position, get_global_mouse_position(), 20 * delta)

func __init(_value : float, _block_type : String, _position : Vector2) -> void:
	self.value = _value
	self.BlockType = _block_type
	self.position = _position

func get_value() -> float:
	return value


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			if event.pressed and GAMEMANAGER.current_dragging == null:
				GAMEMANAGER.block_in_mouse_area.clear()
				await get_tree().process_frame
				GAMEMANAGER.block_in_mouse_area.append(self)
				GAMEMANAGER.detect_top_block()
				if GAMEMANAGER.on_top_block == self:
					is_dragging = true
					GAMEMANAGER.current_dragging = self
					GAMEMANAGER.bring_to_front()
			else:
				is_dragging = false	
				if GAMEMANAGER.current_dragging == self:
					GAMEMANAGER.current_dragging = null

func update_value_label():
	if get_value() == int(get_value()):
		num_rich_text_label.text = str(int(get_value()))
	else:
		num_rich_text_label.text = str(get_value())
