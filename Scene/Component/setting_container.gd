extends Control

@export var root_btn : Control

@onready var panel: Panel = $Panel
@onready var bg_panel: Panel = $Bg_Panel

var setting_tween : Tween
var off_setting_tween : Tween
var stylebox : StyleBoxFlat

func _ready() -> void:
	stylebox = panel.get_theme_stylebox("panel").duplicate()

func _on_that_btn_pressed_u_know():
	var tween_corner_radius_target_friend = 100
	var tween_corner_radius_target_nfriend = 1000
	var tween_corner_radius_time = 0.15
	var tween_expand_margins_time = 0.2
	
	setting_tween = get_tree().create_tween()
	setting_tween.set_parallel(true)
	panel.add_theme_stylebox_override("panel", stylebox)
	setting_tween.tween_method(
		func(val):	set_panel_corner_radius(stylebox, "Top Right", val),
		stylebox.corner_radius_top_right,
		tween_corner_radius_target_friend,
		tween_corner_radius_time
	)
	
	setting_tween.tween_method(
		func(val):	set_panel_corner_radius(stylebox, "Bottom Right", val),
		stylebox.corner_radius_bottom_right,
		tween_corner_radius_target_nfriend,
		tween_corner_radius_time
	)
	
	setting_tween.tween_method(
		func(val):	set_panel_corner_radius(stylebox, "Bottom Left", val),
		stylebox.corner_radius_bottom_left,
		tween_corner_radius_target_friend,
		tween_corner_radius_time
	)
	
	setting_tween.tween_method(
		func(val): set_panel_expand_margins(stylebox, "Right", val),
		stylebox.expand_margin_right,
		1200,
		tween_expand_margins_time
	)
	
	setting_tween.tween_method(
		func(val): set_panel_expand_margins(stylebox, "Bottom", val),
		stylebox.expand_margin_bottom,
		800,
		tween_expand_margins_time
	)


func _on_button_pressed() -> void:
	off_setting_tween = get_tree().create_tween()
	var tween_corner_radius_TR : int = 300
	var tween_corner_radius_BR : int = 450
	var tween_corner_radius_BL : int = 300
	var tween_corner_radius_time = 0.3
	var tween_expand_margins_time = 0.15
	off_setting_tween.set_parallel(true)
	panel.add_theme_stylebox_override("panel", stylebox)
	off_setting_tween.tween_method(
		func(val):	set_panel_corner_radius(stylebox, "Top Right", val),
		stylebox.corner_radius_top_right,
		tween_corner_radius_TR,
		tween_corner_radius_time
	)
	
	off_setting_tween.tween_method(
		func(val):	set_panel_corner_radius(stylebox, "Bottom Right", val),
		stylebox.corner_radius_bottom_right,
		tween_corner_radius_BR,
		tween_corner_radius_time
	)
	
	off_setting_tween.tween_method(
		func(val):	set_panel_corner_radius(stylebox, "Bottom Left", val),
		stylebox.corner_radius_bottom_left,
		tween_corner_radius_BL,
		tween_corner_radius_time
	)
	
	off_setting_tween.tween_method(
		func(val): set_panel_expand_margins(stylebox, "Right", val),
		stylebox.expand_margin_right,
		0,
		tween_expand_margins_time
	)
	
	off_setting_tween.tween_method(
		func(val): set_panel_expand_margins(stylebox, "Bottom", val),
		stylebox.expand_margin_bottom,
		0,
		tween_expand_margins_time
	)
	
	await get_tree().create_timer(0.3).timeout
	self.visible = false
	root_btn.visible = true


func set_panel_corner_radius(stylebox : StyleBox, which: String, r : float):
	match which:
		"Top Left":
			stylebox.corner_radius_top_left = int(r)
		"Top Right":
			stylebox.corner_radius_top_right = int(r)
		"Bottom Left":
			stylebox.corner_radius_bottom_left = int(r)
		"Bottom Right":
			stylebox.corner_radius_bottom_right = int(r)
		_:
			pass
	queue_redraw()

func set_panel_expand_margins(stylebox : StyleBox, which : String, l : float):
	match which:
		"Top":
			stylebox.expand_margin_top = int(l)
		"Bottom":
			stylebox.expand_margin_bottom = int(l)
		"Left":
			stylebox.expand_margin_left = int(l)
		"Right":
			stylebox.expand_margin_right = int(l)
		_:
			pass
