extends Block

@export var op_type : String
var input_a : Area2D = null
var input_b : Area2D = null
var temp_input_a : Area2D = null
var temp_input_b : Area2D = null
var output : float = 0


@onready var operand_a: Area2D = $OperatorBlock/Operand_A
@onready var operand_b: Area2D = $OperatorBlock/Operand_B
@onready var operator_rich_text_label: RichTextLabel = $OperatorRichTextLabel
@onready var output_rich_text_label: RichTextLabel = $OutputRichTextLabel

func _ready() -> void:
	update_rich_text_label(operator_rich_text_label, op_type)
	update_rich_text_label(output_rich_text_label, str(output))

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("MOUSE_BUTTON_LEFT"):
		if GAMEMANAGER.current_dragging == self:
			global_position = lerp(global_position, get_global_mouse_position(), 20 * delta)
			if input_a:
				input_a.global_position = operand_a.global_position
			if input_b:
				input_b.global_position = operand_b.global_position
		if GAMEMANAGER.current_dragging == input_a:
			input_a = null
			update_result()
		if GAMEMANAGER.current_dragging == input_b:
			input_b = null
			update_result()

	if Input.is_action_just_released("MOUSE_BUTTON_LEFT"):
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
		# '/':	output = input_a.value - input_b.value

	update_rich_text_label(output_rich_text_label, str(output))

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			if event.pressed and GAMEMANAGER.current_dragging == null and !is_mouse_in_area(operand_a) and !is_mouse_in_area(operand_b):
				is_dragging = true
				GAMEMANAGER.current_dragging = self
				GAMEMANAGER.bring_to_front()
			else:
				is_dragging = false
				GAMEMANAGER.current_dragging = null

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
		temp_input_b = area

func _on_operand_b_area_exited(area: Area2D) -> void:
	if area == input_b:
		input_b = null

func update_rich_text_label(label : RichTextLabel, text : String):
	label.text = text
