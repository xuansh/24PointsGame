extends Block

class_name TransformBlock

var operator_block : OperatorBlock = null
var temp_operator_block : Area2D = null

@export var root : Node2D = null

@onready var target_operator_block : Area2D = $Sprite2D/OperatorBlock
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var transform_button: Button = $Button

func _ready() -> void:
	pass

func __init(_pos : Vector2) -> void:
	self.position = _pos

func _process(delta: float) -> void:
	if Input.is_action_pressed("MOUSE_BUTTON_LEFT"):
		if GAMEMANAGER.current_dragging == self:
			self.global_position = lerp(global_position, get_global_mouse_position(), 20 * delta)
			self.scale = lerp(self.scale, GAMEMANAGER.MAX_PRESS_SCALE, 0.5)
			if operator_block:
				operator_block.global_position = target_operator_block.global_position
				operator_block.scale = lerp(operator_block.scale, GAMEMANAGER.MAX_PRESS_SCALE, 0.5)
				if operator_block.input_a:
					operator_block.input_a.global_position = operator_block.operand_a.global_position
					operator_block.input_a.scale = lerp(operator_block.input_a.scale, GAMEMANAGER.MAX_PRESS_SCALE, 0.5)
				if operator_block.input_b:
					operator_block.input_b.global_position = operator_block.operand_b.global_position
					operator_block.input_b.scale = lerp(operator_block.input_b.scale, GAMEMANAGER.MAX_PRESS_SCALE, 0.5)
		if GAMEMANAGER.current_dragging == operator_block:
			operator_block = null
			update_transform_color(Color(0.078, 0.16, 0.051, 1.0))
			
	
	else:
		self.scale = lerp(self.scale, GAMEMANAGER.MIN_PRESS_SCALE, 0.5)
		if operator_block:
			operator_block.scale = lerp(operator_block.scale, GAMEMANAGER.MIN_PRESS_SCALE, 0.5)
			if operator_block.input_a:
				operator_block.input_a.scale = lerp(operator_block.input_a.scale, GAMEMANAGER.MIN_PRESS_SCALE, 0.5)
			if operator_block.input_b:
				operator_block.input_b.scale = lerp(operator_block.input_b.scale, GAMEMANAGER.MIN_PRESS_SCALE, 0.5)
			if not operator_block.able_to_output_num():
				update_transform_color(Color(0.078, 0.16, 0.051, 1.0))
		if target_operator_block.has_overlapping_areas() and temp_operator_block != null and target_operator_block.global_position.distance_to(temp_operator_block.global_position) < (target_operator_block.get_child(0).shape.size.x * 0.7):
			var tween = create_tween()
			tween.set_trans(Tween.TRANS_BACK)
			tween.set_ease(Tween.EASE_OUT)
			tween.tween_property(temp_operator_block, "global_position", target_operator_block.global_position, 0.1)
			operator_block = temp_operator_block
			if operator_block.able_to_output_num():
				update_transform_color(Color(0.569, 1.0, 0.427, 1.0))
		

func update_transform_color(color : Color):
	var mat = transform_button.material as ShaderMaterial
	mat.set_shader_parameter("bg_color", color)

func output_NumberBlock() -> void:
	if operator_block:
		pass

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			if event.pressed and GAMEMANAGER.current_dragging == null:
				GAMEMANAGER.block_in_mouse_area.append(self)
			else:
				is_dragging = false

func _on_operator_block_area_entered(area: Area2D) -> void:
	if area.is_in_group("OperatorArea") and operator_block == null and area.is_dragging:
		temp_operator_block = area

func _on_operator_block_area_exited(area: Area2D) -> void:
	if area == operator_block:
		operator_block = null


func _on_button_button_up() -> void:
	if operator_block:
		if operator_block.BlockType == 'Operator':
			if operator_block.able_to_output_num():
				if !is_nan(operator_block.get_value()):
					GAMEMANAGER.spawn_a_NumberBlock(operator_block.get_value(), "Number", self)
					operator_block._queue_free_two_input()
					update_transform_color(Color(0.078, 0.16, 0.051, 1.0))
