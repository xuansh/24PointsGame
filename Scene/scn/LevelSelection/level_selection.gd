extends Control

var BUTTON = preload("uid://b0khynwj31ywl")
@onready var grid_container: GridContainer = $Panel/ScrollContainer/GridContainer

func _ready() -> void:
	var list : Array[String] = MAPINSTANTIATE.return_all_map_list()
	for i in list.size():
		var filename_noextension = list[i].split('.')[0]
		if filename_noextension == str(i + 1):
			var b = BUTTON.instantiate()
			b.level_id = filename_noextension
			grid_container.add_child(b)
