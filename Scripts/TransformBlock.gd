extends Block

var operator_block : Area2D = null
var temp_operator_block : Area2D = null

@onready var target_operator_block : Area2D = $Sprite2D/OperatorBlock
const NUMBER_BLOCK = preload("uid://cxqvbxwc4eu0y")

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("MOUSE_BUTTON_LEFT"):
		if GAMEMANAGER.current_dragging == self:
			global_position = lerp(global_position, get_global_mouse_position(), 20 * delta)
			if operator_block:
				operator_block.global_position = target_operator_block.global_position
		if GAMEMANAGER.current_dragging == operator_block:
			operator_block = null
	
	if Input.is_action_just_released("MOUSE_BUTTON_LEFT"):
		if target_operator_block.has_overlapping_areas() and temp_operator_block != null and target_operator_block.global_position.distance_to(temp_operator_block.global_position) < (target_operator_block.get_child(0).shape.size.x * 0.7):
			temp_operator_block.global_position = target_operator_block.global_position
			operator_block = temp_operator_block

func output_NumberBlock() -> void:
	if operator_block:
		pass

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			if event.pressed and GAMEMANAGER.current_dragging == null:
				is_dragging = true
				GAMEMANAGER.current_dragging = self
				GAMEMANAGER.bring_to_front()
				print("Transform")
			else:
				is_dragging = false
				GAMEMANAGER.current_dragging = null

func _on_operator_block_area_entered(area: Area2D) -> void:
	if area.is_in_group("OperatorArea") and operator_block != null and area.is_dragging:
		temp_operator_block = area

func _on_operator_block_area_exited(area: Area2D) -> void:
	if area == operator_block:
		operator_block = null
