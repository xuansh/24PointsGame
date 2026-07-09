extends Block

class_name NumberBlock

@onready var num_rich_text_label: RichTextLabel = $NumRichTextLabel
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var root : Node2D = null
@export var value : float
@export var is_dragable : bool = true



# only on Debug
func _ready() -> void:
	update_value_label()

func _process(delta: float) -> void:
	if Input.is_action_pressed("MOUSE_BUTTON_LEFT"):
		if GAMEMANAGER.current_dragging == self:
			global_position = lerp(global_position, get_global_mouse_position(), 20 * delta)
			#using Tween may be fitable to input.position 
			self.scale = lerp(self.scale, GAMEMANAGER.MAX_PRESS_SCALE, 0.5) #**按压缩放**

	else:
		self.scale = lerp(self.scale, GAMEMANAGER.MIN_PRESS_SCALE, 0.5)

func __init(_value : float, _position : Vector2) -> void:
	self.value = _value
	self.position = _position
	#update_value_label()

func get_value() -> float:
	return value


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and is_dragable:
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			if event.pressed and GAMEMANAGER.current_dragging == null:
				GAMEMANAGER.block_in_mouse_area.append(self)
			else:
				if is_dragging:
					is_dragging = false
					print_rich("[color=yellow]NB is releasing[/color]")
					

func update_value_label():
	if get_value() == int(get_value()):
		num_rich_text_label.text = str(int(get_value()))
	else:
		num_rich_text_label.text = str(get_value())
