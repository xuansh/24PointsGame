extends Node

var current_dragging : Block = null
var tmp_dragging : Block = null
var z_index : int = 1

func bring_to_front() -> void:
	if current_dragging:
		z_index += 1
		current_dragging.z_index = z_index
		if current_dragging.BlockType == "Operator":
			if current_dragging.input_a:
				z_index += 1
				current_dragging.input_a.z_index = z_index
			if current_dragging.input_b:
				z_index += 1
				current_dragging.input_b.z_index = z_index
