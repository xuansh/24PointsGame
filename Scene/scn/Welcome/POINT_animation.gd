extends Control

@export var delay_time : float = 0.0

var tween : Tween
var tween_target_scale : float = 1.08
var tween_origin_scale : float = 1.0
var tween_origin_rotation_degrees : float = 0.0
var tween_scale_time_x : float = 0.3
var tween_scale_time_y : float = 0.45
var tween_rotation_time : float = 0.25
var tween_rotation_recovery_time : float = 0.35
var tween_scale_ratio : float = 0.6


func _ready() -> void:
	tween_origin_rotation_degrees = self.rotation_degrees
	
	await get_tree().create_timer(delay_time).timeout
	if tween and tween.is_running():
		tween.kill()

	tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.set_loops()
	#NOTICE GO
	tween.tween_property(self, "scale:x", tween_target_scale, tween_scale_time_x)
	tween.parallel().tween_property(self, "scale:y", tween_target_scale, tween_scale_time_y)
	tween.parallel().tween_property(self, "rotation_degrees", 5.0 * tween_scale_ratio * (-1.0 if tween_origin_rotation_degrees > 0 else 1.0), tween_rotation_time)
	
	#NOTICE BACK
	tween.tween_property(self, "rotation_degrees", tween_origin_rotation_degrees, tween_rotation_recovery_time)
	tween.tween_property(self, "scale:x", tween_origin_scale, tween_scale_time_x)
	tween.parallel().tween_property(self, "scale:y", tween_origin_scale, tween_scale_time_y)
