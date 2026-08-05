extends Control

@export var root : Control
@export var root_btn : Control

@onready var panel: Panel = $Panel
@onready var bg_panel: Panel = $Bg_Panel
@onready var close_button: TextureButton = $CloseButton
@onready var home_button: TextureButton = $HomeButton

const WELCOME_SCREEN_PATH = "res://Scene/scn/Welcome/WelcomeScreen.tscn"

var setting_tween : Tween
var off_setting_tween : Tween
var bg_tween : Tween
var off_bg_tween : Tween
var spawn_tween : Tween
var destory_tween : Tween
var stylebox : StyleBoxFlat
var bg_stylebox : StyleBoxFlat

var open_config = {}
var close_config = {}

func _ready() -> void:
	stylebox = panel.get_theme_stylebox("panel").duplicate()
	bg_stylebox = bg_panel.get_theme_stylebox("panel").duplicate()

	close_config = {
		"panel_stylebox": stylebox,
		"bg_stylebox": bg_stylebox,
		"corner_radius": {
			"top_right": 300,
			"bottom_right": 450,
			"bottom_left": 300,
			"top_left": null
		},
		"expand_margins": {
			"right": 0,
			"bottom": 0,
			"left": null,
			"top": null
		},
		"bg_expand_margins": {
			"right": 0,
			"bottom": 0,
			"left": 0,
			"top": 0
		},
		"duration": 0.3,
		"expand_duration": 0.15
	}

	open_config = {
		"panel_stylebox": stylebox,
		"bg_stylebox": bg_stylebox,
		"corner_radius": {
			"top_right": 100,
			"bottom_right": 1000,
			"bottom_left": 100,
			"top_left": null  # null 表示保持不变
		},
		"expand_margins": {
			"right": 1200,
			"bottom": 800,
			"left": null,
			"top": null
		},
		"bg_expand_margins": {
			"right": 1220,
			"bottom": 820,
			"left": 10,
			"top": 10
		},
		"duration": 0.15,
		"expand_duration": 0.2
	}

	home_button.pressed.connect(_on_home_button_pressed)
	close_button.pressed.connect(_on_close_button_pressed)

func _on_that_btn_pressed_u_know():
	animate_panel_open(open_config)
	set_component_spawn(close_button)
	set_component_spawn(home_button)

func _on_close_button_pressed() -> void:
	root._on_pause_menu_shown()
	set_component_destory(close_button)
	set_component_destory(home_button)

	animate_panel_close(close_config)
	await get_tree().create_timer(0.3).timeout
	self.visible = false
	root_btn.visible = true

func _on_home_button_pressed() -> void:
	root._on_pause_menu_shown()
	set_component_destory(close_button)
	set_component_destory(home_button)

	animate_panel_close(close_config)
	await get_tree().create_timer(0.3).timeout
	print(get_tree().change_scene_to_file(WELCOME_SCREEN_PATH))

func animate_panel_open(config: Dictionary) -> void:
	# 主面板动画
	setting_tween = get_tree().create_tween()
	setting_tween.set_parallel(true)
	panel.add_theme_stylebox_override("panel", config.panel_stylebox)

	_animate_stylebox(config.panel_stylebox, config.corner_radius, config.expand_margins,
					  config.duration, config.expand_duration, setting_tween)

	# 背景面板动画
	bg_tween = get_tree().create_tween()
	bg_tween.set_parallel(true)
	bg_panel.add_theme_stylebox_override("panel", config.bg_stylebox)

	_animate_stylebox(config.bg_stylebox, config.corner_radius, config.bg_expand_margins,
					  config.duration, config.expand_duration, bg_tween)

func animate_panel_close(config: Dictionary) -> void:
	# 主面板动画
	off_setting_tween = get_tree().create_tween()
	off_setting_tween.set_parallel(true)
	panel.add_theme_stylebox_override("panel", config.panel_stylebox)

	_animate_stylebox(config.panel_stylebox, config.corner_radius, config.expand_margins,
					  config.duration, config.expand_duration, off_setting_tween)

	# 背景面板动画
	off_bg_tween = get_tree().create_tween()
	off_bg_tween.set_parallel(true)
	bg_panel.add_theme_stylebox_override("panel", config.bg_stylebox)

	_animate_stylebox(config.bg_stylebox, config.corner_radius, config.bg_expand_margins,
					  config.duration, config.expand_duration, off_bg_tween)

func _animate_stylebox(style: StyleBoxFlat, corner_config: Dictionary, margin_config: Dictionary,
					   duration: float, expand_duration: float, tween: Tween) -> void:
	# 处理圆角动画
	if corner_config.has("top_right") and corner_config.top_right != null:
		tween.tween_method(
			func(val): set_panel_corner_radius(style, "Top Right", val),
			style.corner_radius_top_right,
			corner_config.top_right,
			duration
		)

	if corner_config.has("bottom_right") and corner_config.bottom_right != null:
		tween.tween_method(
			func(val): set_panel_corner_radius(style, "Bottom Right", val),
			style.corner_radius_bottom_right,
			corner_config.bottom_right,
			duration
		)

	if corner_config.has("bottom_left") and corner_config.bottom_left != null:
		tween.tween_method(
			func(val): set_panel_corner_radius(style, "Bottom Left", val),
			style.corner_radius_bottom_left,
			corner_config.bottom_left,
			duration
		)

	# 处理边距动画
	if margin_config.has("right") and margin_config.right != null:
		tween.tween_method(
			func(val): set_panel_expand_margins(style, "Right", val),
			style.expand_margin_right,
			margin_config.right,
			expand_duration
		)

	if margin_config.has("bottom") and margin_config.bottom != null:
		tween.tween_method(
			func(val): set_panel_expand_margins(style, "Bottom", val),
			style.expand_margin_bottom,
			margin_config.bottom,
			expand_duration
		)

	if margin_config.has("left") and margin_config.left != null:
		tween.tween_method(
			func(val): set_panel_expand_margins(style, "Left", val),
			style.expand_margin_left,
			margin_config.left,
			expand_duration
		)

	if margin_config.has("top") and margin_config.top != null:
		tween.tween_method(
			func(val): set_panel_expand_margins(style, "Top", val),
			style.expand_margin_top,
			margin_config.top,
			expand_duration
		)

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

func set_component_spawn(com):
	var spawn_scale_time : float = 0.3
	com.scale = Vector2.ZERO
	com.rotation = 0
	com.visible = true
	spawn_tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
	spawn_tween.set_parallel(true)
	spawn_tween.tween_property(com, "scale", Vector2.ONE, spawn_scale_time)

func set_component_destory(com):
	var des_target_scale : Vector2 = Vector2(0.001, 0.001)
	var destroy_scale_time : float = 0.25
	destory_tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
	destory_tween.set_parallel(true)
	destory_tween.tween_property(com, "scale", des_target_scale, destroy_scale_time)
	await get_tree().create_timer(destroy_scale_time).timeout
	com.visible = false
