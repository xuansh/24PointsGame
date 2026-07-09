extends Block

class_name OperatorBlock

@export var op_type : String
var input_a : Area2D = null
var input_b : Area2D = null
var temp_input_a : Area2D = null
var temp_input_b : Area2D = null
var output : float = NAN if self.op_type == "/" else 0.0


@onready var operand_a: Area2D = $OperatorBlock/Operand_A
@onready var operand_b: Area2D = $OperatorBlock/Operand_B
@onready var operator_rich_text_label: RichTextLabel = $OperatorRichTextLabel
@onready var output_rich_text_label: RichTextLabel = $OutputRichTextLabel
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	pass

func __init(_op_type : String, _position : Vector2):
	self.op_type = _op_type
	self.position = _position
	update_rich_text_label(operator_rich_text_label, op_type)
	update_rich_text_label(output_rich_text_label, "NAN" if self.op_type == '/' else str(output))

func _physics_process(delta: float) -> void:
	if input_a:
		input_a.global_position = operand_a.global_position
	if input_b:
		input_b.global_position = operand_b.global_position
	#if U dont use physics_process instead of just '_process', the NumberBlock cant may be adsorb 
	
func _on_quene_free() -> void:
	if input_a:
		input_a.queue_free()
	if input_b:
		input_b.queue_free()
		
func _queue_free_two_input() -> void:
	if input_a:
		input_a.queue_free()
		input_a = null
	if input_b:
		input_b.queue_free()
		input_b = null
	update_result()

func _process(delta: float) -> void:
	if Input.is_action_pressed("MOUSE_BUTTON_LEFT"):
		if GAMEMANAGER.current_dragging == self:
			global_position = lerp(global_position, get_global_mouse_position(), 20 * delta)
			#using Tween may be fitable to input.position 
			self.scale = lerp(self.scale, GAMEMANAGER.MAX_PRESS_SCALE, 0.5) #按压缩放
			if input_a:
				input_a.scale = lerp(input_a.scale, GAMEMANAGER.MAX_PRESS_SCALE, 0.5)
			if input_b:
				input_b.scale = lerp(input_b.scale, GAMEMANAGER.MAX_PRESS_SCALE, 0.5)
		
		if GAMEMANAGER.current_dragging == input_a:
			input_a = null
			update_result()
		if GAMEMANAGER.current_dragging == input_b:
			input_b = null
			update_result()

	if Input.is_action_just_released("MOUSE_BUTTON_LEFT"):
		self.scale = lerp(self.scale, GAMEMANAGER.MIN_PRESS_SCALE, 0.5) #按压缩放
		var scale_tween = create_tween()
		scale_tween.set_trans(Tween.TRANS_BACK)
		scale_tween.set_ease(Tween.EASE_OUT)
		if input_a:
			input_a.scale = lerp(input_a.scale, GAMEMANAGER.MIN_PRESS_SCALE, 0.5)
		if input_b:
			input_b.scale = lerp(input_b.scale, GAMEMANAGER.MIN_PRESS_SCALE, 0.5)
	
		if operand_a.has_overlapping_areas() and temp_input_a != null and operand_a.global_position.distance_to(temp_input_a.global_position) < (operand_a.get_child(0).shape.size.x * 0.7):
			var tween = create_tween()
			tween.set_trans(Tween.TRANS_BACK)
			tween.set_ease(Tween.EASE_OUT)
			tween.tween_property(temp_input_a, "global_position", operand_a.global_position, 0.1)
			input_a = temp_input_a
			update_result()
		
		if operand_b.has_overlapping_areas() and temp_input_b != null and operand_b.global_position.distance_to(temp_input_b.global_position) < (operand_b.get_child(0).shape.size.x * 0.7):
			var tween = create_tween()
			tween.set_trans(Tween.TRANS_BACK)
			tween.set_ease(Tween.EASE_OUT)
			tween.tween_property(temp_input_b, "global_position", operand_b.global_position, 0.1)
			input_b = temp_input_b
			update_result()
		


func update_result():
	var a_value : float = 0 if input_a == null else input_a.value
	var b_value : float = 0 if input_b == null else input_b.value

	match op_type:
		'+':	output = a_value + b_value
		'-':	output = a_value - b_value
		'*':	output = a_value * b_value
		'/':	output = NAN if b_value == 0 else a_value / b_value

	update_rich_text_label(output_rich_text_label, str(output))

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			if event.pressed and GAMEMANAGER.current_dragging == null and !is_mouse_in_area(operand_a) and !is_mouse_in_area(operand_b):
				GAMEMANAGER.block_in_mouse_area.append(self)
			else:
				is_dragging = false

#AI
func is_mouse_in_area(area : Area2D) -> bool:
	var _shape = area.get_node("CollisionShape2D").shape as RectangleShape2D
	var local_mouse = area.to_local(get_global_mouse_position())
	return Rect2(-_shape.size / 2.0, _shape.size).has_point(local_mouse)


func get_value() -> float:
	return output

func _on_operand_a_area_entered(area: Area2D) -> void:
	if area.is_in_group("NumberArea") and input_a == null and area.is_dragging:
		temp_input_a = area

func _on_operand_a_area_exited(area: Area2D) -> void:
	if area == input_a:
		input_a = null

func _on_operand_b_area_entered(area: Area2D) -> void:
	if area.is_in_group("NumberArea") and input_b == null and area.is_dragging:
		if self.op_type == '/' and area.value == 0:
			return
		temp_input_b = area

func _on_operand_b_area_exited(area: Area2D) -> void:
	if area == input_b:
		input_b = null

func update_rich_text_label(label : RichTextLabel, text : String):
	label.text = text

func able_to_output_num() -> bool:
	if op_type == '*':
		if input_a or input_b:
			return true
	elif input_a and input_b:
		return true
	return false
