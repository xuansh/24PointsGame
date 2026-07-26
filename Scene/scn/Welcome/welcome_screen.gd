extends Control


func _on_quit_btn_pressed() -> void:
	get_tree().quit()


func _on_play_button_pressed() -> void:
	GAMEMANAGER.change_to_level_selection_scene()
