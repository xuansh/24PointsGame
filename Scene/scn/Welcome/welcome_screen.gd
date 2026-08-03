extends Control

@export var setting_container : Control
@export var setting_btn: TextureButton
@onready var color_rect: ColorRect = $CanvasLayer/ColorRect

func _ready() -> void:
	setting_container.root_btn = setting_btn
	
func _on_quit_btn_pressed() -> void:
	get_tree().quit()


func _on_play_button_pressed() -> void:
	GAMEMANAGER.change_to_level_selection_scene()


func _on_setting_btn_pressed() -> void:
	setting_btn.visible = false
	setting_container.visible = true
	setting_container._on_that_btn_pressed_u_know()
