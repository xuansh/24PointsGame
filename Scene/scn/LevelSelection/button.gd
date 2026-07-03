extends Button

@export var level_id : int = -1

func _enter_tree() -> void:
	if level_id != -1:
		text = str(level_id)

func _on_pressed() -> void:
	MAPINSANTIATE.load_level(level_id)
	
