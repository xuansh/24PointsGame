extends Node

var current_dragging : Block = null
var tmp_dragging : Block = null
var z_index : int = 1
var on_top_block : Block = null
var block_in_mouse_area : Array[Block]

var NumberBlockContainer : Node2D = null
var OperatorBlockContainer : Node2D = null
var TransformBlockContainer : Node2D = null
var ConditionBlockContainer : Node2D = null
var MainCamera : Camera2D = null

const NUMBER_BLOCK = preload("uid://cxqvbxwc4eu0y")
const CONDITION_BLOCK = preload("uid://yn6ve42dfa63")
const OPERATOR_BLOCK = preload("uid://c7d2p864e5ld2")
const TRANSFORM_BLOCK = preload("uid://bhgipd07tg5dr")

const LevelSelection = preload("uid://bx16mv5li33al")


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
		if current_dragging.BlockType == 'Condition':
			if current_dragging.number_a:
				z_index += 1
				current_dragging.number_a.z_index = z_index
			if current_dragging.number_b:
				z_index += 1
				current_dragging.number_b.z_index = z_index

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
			else:
				block_in_mouse_area = []


func spawn_a_NumberBlock(value : float, BlockType : String, WHO : Block = null) -> void:
	var block : NumberBlock = NUMBER_BLOCK.instantiate()
	block.__init(value, Vector2(WHO.position.x + 117, WHO.position.y + 190))
	NumberBlockContainer.add_child(block)

func destory_a_Block(dest_block : Block):
	dest_block._on_quene_free()
	dest_block.queue_free()
	

func change_to_level_selection_scene():
	get_tree().change_scene_to_packed(LevelSelection)
