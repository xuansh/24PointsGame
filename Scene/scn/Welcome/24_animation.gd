extends Control

var tween : Tween
var squash := Vector2(0.9, 1.1)   # 压扁
var stretch := Vector2(1.1, 0.9)  # 压高
var normal := Vector2(1.0, 1.0)   # 原始比例
var dur := 0.6
var wait_time := 2.0              # 停顿时长

func _ready() -> void:
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.set_loops()                      # 无限循环（原生，零开销）
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)      # 丝滑正弦
	
	# 1. 压扁
	tween.tween_property(self, "scale", squash, dur)
	# 2. 压高
	tween.tween_property(self, "scale", stretch, dur)
	# 3. 回到原始比例
	tween.tween_property(self, "scale", normal, dur)
	# 4. 等待 2 秒（相当于 tween_await）
	tween.tween_interval(wait_time)
	# 5. 自动循环到第 1 步
