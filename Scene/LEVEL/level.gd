extends Control

@onready var setting_btn: TextureButton = $CanvasLayerTop/SETTING_BTN
@onready var blur_back: ColorRect = $CanvasLayerTop/BlurBack
@onready var setting_container: Control = $CanvasLayerTop/SettingContainer



func _on_setting_btn_pressed() -> void:
	setting_btn.visible = false
	setting_container.visible = true
	blur_back.visible = true
	blur_back.mouse_filter = Control.MOUSE_FILTER_STOP
	setting_container._on_that_btn_pressed_u_know()

func _on_pause_menu_shown():
	blur_back.visible = false
	blur_back.mouse_filter = Control.MOUSE_FILTER_STOP
