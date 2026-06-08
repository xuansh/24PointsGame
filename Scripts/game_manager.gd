extends Node

var current_dragging : Block = null
var tmp_dragging : Block = null
var z_index : int = 1
var on_top_block : Block = null
var block_in_mouse_area : Array[Block]
 

func bring_to_front() -> void:
	if current_dragging:
		# print(current_dragging)
		z_index += 1
		current_dragging.z_index = z_index
		if current_dragging.BlockType == "Operator":
			if current_dragging.input_a:
				z_index += 1
				current_dragging.input_a.z_index = z_index
			if current_dragging.input_b:
				z_index += 1
				current_dragging.input_b.z_index = z_index
		if current_dragging.BlockType == "Transform":
			if current_dragging.operator_block:
				z_index += 1
				current_dragging.operator_block.z_index = z_index
				if current_dragging.operator_block.input_a:
					z_index += 1
					current_dragging.operator_block.input_a.z_index = z_index
				if current_dragging.operator_block.input_b:
					z_index += 1
					current_dragging.operator_block.input_b.z_index = z_index

func detect_top_block() -> void:
	var max_z_index = -999
	for stack_block in block_in_mouse_area:
		if stack_block.z_index > max_z_index:
			max_z_index = stack_block.z_index
			on_top_block = stack_block

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				await get_tree().process_frame
				detect_top_block()
				if block_in_mouse_area.size() > 0:
					print(block_in_mouse_area)
			else:
				block_in_mouse_area = []
