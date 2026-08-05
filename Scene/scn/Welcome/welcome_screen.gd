extends Control

@export var setting_container : Control
@export var setting_btn: TextureButton
@onready var color_rect: ColorRect = $CanvasLayer/ColorRect
@onready var blur_back: ColorRect = $BlurBack
@onready var level_selection: Control = $LevelSelection

func _ready() -> void:
	setting_container.root_btn = setting_btn
	
func _on_quit_btn_pressed() -> void:
	get_tree().quit()


func _on_play_button_pressed() -> void:
	level_selection.visible = true
	blur_back.visible = true


func _on_setting_btn_pressed() -> void:
	setting_btn.visible = false
	setting_container.visible = true
	blur_back.visible = true
	blur_back.mouse_filter = Control.MOUSE_FILTER_STOP
	setting_container._on_that_btn_pressed_u_know()

func _on_pause_menu_shown():
	blur_back.visible = false
	blur_back.mouse_filter = Control.MOUSE_FILTER_STOP
