extends Area2D

class_name Block

@export var BlockType : String = ""

var is_dragging : bool = false

func _on_quene_free() -> void:
	pass

func is_mouse_in_area(area : Area2D) -> bool:
	var _shape = area.get_node("CollisionShape2D").shape as RectangleShape2D
	var local_mouse = area.to_local(get_global_mouse_position())
	return Rect2(-_shape.size / 2.0, _shape.size).has_point(local_mouse)
