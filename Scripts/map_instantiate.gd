extends Node

@export var level : String = ""
@onready var scn = preload("uid://duxbvplv6d4r7")
var count = 0

func load_level(l : int) -> void:
	match l:
		1:
			var level = "uid://h63eni0jqevq"
			get_tree().change_scene_to_packed(scn)
			while GAMEMANAGER.OperatorBlockContainer == null:
				await get_tree().process_frame
			decrypt_csv(level)
		_:
			pass

func decrypt_csv(level : String):
	var file = FileAccess.open(level, FileAccess.READ)
	while !file.eof_reached():
		var line = file.get_csv_line()
		count += 1
		print(count)
		instantiate_map(line)

func instantiate_map(line  : PackedStringArray):
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
			GAMEMANAGER.ConditionBlockContainer.add_child(CB)
			CB.__init(NB, _pos)
			
		_:
			pass

func string_to_vector2(_str):
	var stri = _str.strip_edges().trim_prefix("(").trim_suffix(")").split(",")
	return Vector2(float(stri[0]), float(stri[1]))
