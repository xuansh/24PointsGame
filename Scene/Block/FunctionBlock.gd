extends Block

class_name FunctionBlock

@onready var target_a : Area2D = $X_sprite/A
@onready var target_x : Area2D = $X_sprite/X
@onready var target_b : Area2D = $X_sprite/B

@export var value : float

var a : NumberBlock = null
var x : NumberBlock = null
var b : NumberBlock = null
var temp_a : NumberBlock = null
var temp_x : NumberBlock = null
var temp_b : NumberBlock = null

func __init(num_a : NumberBlock, num_b : NumberBlock, _pos : Vector2):
	self.global_position = _pos
	if num_a and num_b:
		self.a = num_a
		self.b = num_b
		a.global_position = target_a.global_position
		b.global_position = target_b.global_position
		a.z_index = self.z_index + 1
		b.z_index = self.z_index + 1
		a.is_dragable = false
		b.is_dragable = false
		GAMEMANAGER.NumberBlockContainer.add_child(num_a)
		GAMEMANAGER.NumberBlockContainer.add_child(num_b)
	
func _physics_process(delta: float) -> void:
	if x:
		x.global_position = target_a.global_position

func _process(delta: float) -> void:
	if Input.is_action_pressed("MOUSE_BUTTON_LEFT"):
		if GAMEMANAGER.current_dragging == self:
			global_position = lerp(global_position, get_global_mouse_position(), 20 * delta)
			self.scale = lerp(self.scale, GAMEMANAGER.MAX_PRESS_SCALE, 0.5)
			if a:
				a.global_position = target_a.global_position
				a.scale = lerp(a.scale, GAMEMANAGER.MAX_PRESS_SCALE, 0.5)
			if x:
				x.scale = lerp(x.scale, GAMEMANAGER.MAX_PRESS_SCALE, 0.5)
			if b:
				b.global_position = target_b.global_position
				b.scale = lerp(b.scale, GAMEMANAGER.MAX_PRESS_SCALE, 0.5)
		if GAMEMANAGER.current_dragging == a:
			a = null
		if GAMEMANAGER.current_dragging == x:
			x = null
		if GAMEMANAGER.current_dragging == b:
			b = null
	else:
		self.scale = lerp(self.scale, GAMEMANAGER.MIN_PRESS_SCALE, 0.5)
		if a:
			a.global_position = target_a.global_position
			a.scale = lerp(a.scale, GAMEMANAGER.MIN_PRESS_SCALE, 0.5)
		if x:
			x.global_position = target_x.global_position
			x.scale = lerp(x.scale, GAMEMANAGER.MIN_PRESS_SCALE, 0.5)
		if b:
			b.global_position = target_b.global_position
			b.scale = lerp(b.scale, GAMEMANAGER.MIN_PRESS_SCALE, 0.5)
		if target_a.has_overlapping_areas() and temp_a != null and target_a.global_position.distance_to(temp_a.global_position) < (target_a.get_child(0).shape.size.x * 0.7):
			var tween = create_tween()
			tween.set_trans(Tween.TRANS_BACK)
			tween.set_ease(Tween.EASE_OUT)
			tween.tween_property(temp_a, "global_position", target_a.global_position, 0.1)
			a = temp_a # **这行就是之前说的 用于存储吸附动画结束前的吸附物
			
		if target_b.has_overlapping_areas() and temp_b != null and target_b.global_position.distance_to(temp_b.global_position) < (target_b.get_child(0).shape.size.x * 0.7):
			var tween = create_tween()
			tween.set_trans(Tween.TRANS_BACK)
			tween.set_ease(Tween.EASE_OUT)
			tween.tween_property(temp_b, "global_position", target_b.global_position, 0.1)
			b = temp_b
		
		if target_x.has_overlapping_areas() and temp_x != null and target_x.global_position.distance_to(temp_x.global_position) < (target_x.get_child(0).shape.size.x * 0.7):
			var tween = create_tween()
			tween.set_trans(Tween.TRANS_BACK)
			tween.set_ease(Tween.EASE_OUT)
			tween.tween_property(temp_x, "global_position", target_x.global_position, 0.1)
			x = temp_x

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT and !is_mouse_in_area(target_a) and !is_mouse_in_area(target_x) and !is_mouse_in_area(target_b):
			if event.pressed and GAMEMANAGER.current_dragging == null:
				GAMEMANAGER.block_in_mouse_area.append(self)
			else:
				if is_dragging:
					is_dragging = false


func get_value() -> float:
	return value

#region target signal

func _on_a_area_entered(area: Area2D) -> void:
	if area.is_in_group("NumberArea") and a == null and area.is_dragging:
		temp_a = area

func _on_a_area_exited(area: Area2D) -> void:
	if area == a:
		a = null

func _on_x_area_entered(area: Area2D) -> void:
	if area.is_in_group("NumberArea") and x == null and area.is_dragging:
		temp_x = area

func _on_x_area_exited(area: Area2D) -> void:
	if area == x:
		x = null

func _on_b_area_entered(area: Area2D) -> void:
	if area.is_in_group("NumberArea") and b == null and area.is_dragging:
		temp_b = area

func _on_b_area_exited(area: Area2D) -> void:
	if area == b:
		b = null

#endregion
