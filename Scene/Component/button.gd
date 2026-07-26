extends TextureButton

@export var btn_text : String = ""

@onready var label : Label = $Label
@onready var panel: Panel = $Panel

@export var enter_btn : StyleBox
@export var exit_btn : StyleBox
@export var enter_label_color : Color
@export var exit_label_color : Color


var origin_label_color : Color

var go_tween : Tween
var back_tween : Tween
var tween_target_scale : float = 1.08
var tween_origin_scale : float = 1.0
var tween_origin_rotation_degrees : float = 0.0
var tween_scale_time_x : float = 0.12
var tween_scale_time_y : float = 0.25
var tween_rotation_time : float = 0.1
var tween_rotation_recovery_time : float = 0.1
var tween_scale_ratio : float = 0.6

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	(func():
		label.text = btn_text
		origin_label_color = label.get_theme_color("font_color")
		label.add_theme_color_override("font_color", exit_label_color)
		panel.add_theme_stylebox_override("panel", exit_btn)
	).call_deferred()
	
	print(panel)

func _on_mouse_entered() -> void:
	print(btn_text)
	panel.add_theme_stylebox_override("panel", enter_btn)
	label.add_theme_color_override("font_color", enter_label_color)

	tween_origin_rotation_degrees = self.rotation_degrees

	if go_tween and go_tween.is_running():
		go_tween.kill()

	go_tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	#NOTICE GO
	go_tween.tween_property(self, "scale:x", tween_target_scale, tween_scale_time_x)
	go_tween.parallel().tween_property(self, "scale:y", tween_target_scale, tween_scale_time_y)
	go_tween.parallel().tween_property(self, "rotation_degrees", 5.0 * tween_scale_ratio * [-1.0, 1.0].pick_random(), tween_rotation_time)



func _on_mouse_exited() -> void:
	panel.add_theme_stylebox_override("panel", exit_btn)
	label.add_theme_color_override("font_color", origin_label_color)

	if back_tween and back_tween.is_running():
		back_tween.kill()

	back_tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

	#NOTICE BACK
	back_tween.tween_property(self, "rotation_degrees", tween_origin_rotation_degrees, tween_rotation_recovery_time)
	back_tween.tween_property(self, "scale:x", tween_origin_scale, tween_scale_time_x)
	back_tween.parallel().tween_property(self, "scale:y", tween_origin_scale, tween_scale_time_y)
