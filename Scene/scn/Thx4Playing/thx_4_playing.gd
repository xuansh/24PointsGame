extends Control

var scn_path : String

func _process(delta: float) -> void:
	var process = []
	if scn_path:
		var loaded_status = ResourceLoader.load_threaded_get_status(scn_path, process)
		if loaded_status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
			var packed_scene = ResourceLoader.load_threaded_get(scn_path)
			get_tree().change_scene_to_packed(packed_scene)
			#await get_tree().process_frame

func _on_level_pressed() -> void:
	scn_path = "res://Scene/scn/LevelSelection/LevelSelection.tscn"
	ResourceLoader.load_threaded_request(scn_path)


func _on_exit_pressed() -> void:
	get_tree().quit()
