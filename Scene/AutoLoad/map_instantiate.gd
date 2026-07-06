extends Node

#@export var level : String = ""
var path = ""
var scn_path : String = "res://Scene/LEVEL/Level.tscn"
var count = 0
var tmp_level_id : int
const THX_4_PLAYING = preload("uid://dahth4l13n4ip")


func _process(delta: float) -> void:
	var process = []
	if path:
		var loaded_status = ResourceLoader.load_threaded_get_status(scn_path, process)
		if loaded_status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
			var loaded_scene : PackedScene = ResourceLoader.load_threaded_get(scn_path)
			get_tree().change_scene_to_packed(loaded_scene)
			await get_tree().process_frame
			decrypt_csv(path)
			path = ""
		

func load_level(l : int) -> void:
	path = "res://Maps/" + str(l) + ".txt"
	tmp_level_id = l
	ResourceLoader.load_threaded_request(scn_path, "")
	

func decrypt_csv(level : String):
	var file = FileAccess.open(level, FileAccess.READ)
	if file:
		GAMEMANAGER.level_id = tmp_level_id
		while !file.eof_reached():
			var line = file.get_csv_line()
			count += 1
			instantiate_map(line)
	else:
		get_tree().change_scene_to_packed(THX_4_PLAYING)
		await get_tree().process_frame

func instantiate_map(line : PackedStringArray):
	match line[0]:
		"OperatorBlock":
			var OB : OperatorBlock = GAMEMANAGER.OPERATOR_BLOCK.instantiate()
			var _op_type : String = line[1]
			var _pos = string_to_vector2(line[2])
			GAMEMANAGER.OperatorBlockContainer.add_child(OB)
			OB.__init(_op_type, _pos)
		
		"NumberBlock":
			var NB : NumberBlock = GAMEMANAGER.NUMBER_BLOCK.instantiate()
			var _value = float(line[1])
			var _pos = string_to_vector2(line[2])
			NB.__init(_value, _pos)
			GAMEMANAGER.NumberBlockContainer.add_child(NB)
		
		"TransformBlock":
			var TB : TransformBlock = GAMEMANAGER.TRANSFORM_BLOCK.instantiate()
			var _pos = string_to_vector2(line[1])
			GAMEMANAGER.TransformBlockContainer.add_child(TB)
			TB.__init(_pos)
		
		"ConditionBlock":
			var CB : ConditionBlock = GAMEMANAGER.CONDITION_BLOCK.instantiate()
			var NB : NumberBlock = null
			if line[1] == 't':
				NB = GAMEMANAGER.NUMBER_BLOCK.instantiate()
				var _value = float(line[2])
				NB.__init(_value, Vector2.ZERO)
			var _pos = string_to_vector2(line[3])
			if GAMEMANAGER.ConditionBlockContainer:
				GAMEMANAGER.ConditionBlockContainer.add_child(CB)
			CB.__init(NB, _pos)
			
		_:
			pass

func string_to_vector2(_str):
	var stri = _str.strip_edges().trim_prefix("(").trim_suffix(")").split(",")
	return Vector2(float(stri[0]), float(stri[1]))
	

func return_all_map_list() -> PackedStringArray:
	var filepath_arr : Array[String] = []
	var path : String = "res://Maps"
	var dir := DirAccess.open(path)
	if dir:
		return (dir.get_files())
	return []
