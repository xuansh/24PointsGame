extends Node

var current_dragging : Block = null
var tmp_dragging : Block = null
var z_index : int = 1
var on_top_block : Block = null
var block_in_mouse_area : Array[Block]
var level_id : int
var is_completed : bool = false

var mouse_speed : float = 0.0
var is_calculate_mouse_speed : bool = true
var last_pos : Vector2


var AllBlockContainers : Array[Node2D] = []
var NumberBlockContainer : Node2D = null
var OperatorBlockContainer : Node2D = null
var TransformBlockContainer : Node2D = null
var ConditionBlockContainer : Node2D = null
var FunctionBlockContainer : Node2D = null
var MainCamera : Camera2D = null

var current_scene : Node = null:
	get:
		return get_tree().current_scene

const MAX_PRESS_SCALE = Vector2(1.2, 1.2)
const MIN_PRESS_SCALE = Vector2(1.0, 1.0)
const NUMBER_BLOCK = preload("uid://cxqvbxwc4eu0y")
const CONDITION_BLOCK = preload("uid://yn6ve42dfa63")
const OPERATOR_BLOCK = preload("uid://c7d2p864e5ld2")
const TRANSFORM_BLOCK = preload("uid://bhgipd07tg5dr")
const FUNCTION_BLOCK = preload("uid://dk5xsi8llo1xe")

const LevelSelection = preload("res://Scene/scn/LevelSelection/LevelSelection.tscn")


func _ready() -> void:
	last_pos = get_viewport().get_mouse_position()

func _process(delta: float) -> void:
	var process = []
	#var loaded_status = ResourceLoader.load_threaded_get_status()
	#print(current_dragging)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				block_in_mouse_area.clear()
				await get_tree().process_frame
				detect_top_block()
				if on_top_block:
					on_top_block.is_dragging = true
					current_dragging = on_top_block
					bring_to_front()
			else:
				if current_dragging:
					current_dragging.is_dragging = false
					current_dragging = null
				block_in_mouse_area.clear()
		if is_calculate_mouse_speed:
			var now_pos = event.position
			var delta_pos = now_pos - last_pos
			var speed_frame = delta_pos.length()
			last_pos = now_pos
			#print(speed_frame)

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
		if current_dragging.BlockType == 'Function':
			if current_dragging.a:
				z_index += 1
				current_dragging.a.z_index = z_index
			if current_dragging.b:
				z_index += 1
				current_dragging.b.z_index = z_index
			if current_dragging.x:
				z_index += 1
				current_dragging.x.z_index = z_index
func detect_top_block() -> void:
	on_top_block = null
	var max_z_index = -999
	for stack_block in block_in_mouse_area:
		if stack_block.z_index > max_z_index:
			max_z_index = stack_block.z_index
			on_top_block = stack_block

func spawn_a_NumberBlock(value : float, BlockType : String, target_pos : Vector2) -> NumberBlock:
	var block : NumberBlock = NUMBER_BLOCK.instantiate()
	block.__init(value, target_pos)
	NumberBlockContainer.add_child(block)
	return block

#func destory_a_Block(dest_block : Block):
	#dest_block._on_quene_free()
	#dest_block.queue_free()


func change_to_level_selection_scene():
	get_tree().change_scene_to_packed(LevelSelection)


func get_mouse_speed():
	is_calculate_mouse_speed = true
	await get_tree().process_frame

func print_all_block_position():
	AllBlockContainers = []
	AllBlockContainers.append(NumberBlockContainer)
	AllBlockContainers.append(OperatorBlockContainer)
	AllBlockContainers.append(TransformBlockContainer)
	AllBlockContainers.append(ConditionBlockContainer)
	AllBlockContainers.append(FunctionBlockContainer)
	for cont in AllBlockContainers:
		for block in cont.get_children():
			print(block.name + str(block.global_position))
