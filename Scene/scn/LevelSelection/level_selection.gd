extends Control

var BUTTON = preload("uid://d4ee3dmnx8ypa")
@onready var grid_container: GridContainer = $Panel/ScrollContainer/GridContainer


@export var enter_btn : StyleBox
@export var exit_btn : StyleBox
@export var enter_label_color : Color
@export var exit_label_color : Color


func _ready() -> void:
	var list : PackedStringArray = MAPINSTANTIATE.return_all_map_list()
	for i in list.size():
		var filename_noextension = list[i].split('.')[0]
		if filename_noextension == str(i + 1):
			var b = BUTTON.instantiate()
			b.enter_label_color = enter_label_color
			b.exit_label_color = exit_label_color
			b.enter_btn = enter_btn
			b.exit_btn = exit_btn
			b.btn_text = filename_noextension
			grid_container.add_child(b)
