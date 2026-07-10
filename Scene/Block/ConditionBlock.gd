extends Block

class_name ConditionBlock

var value : bool = false
var number_a : NumberBlock = null
var temp_number_a : NumberBlock = null
var number_b : NumberBlock = null
var temp_number_b : NumberBlock = null
var is_level_condition : bool = false

@onready var target_number_a: Area2D = $Sprite2D/Number_a
@onready var target_number_b: Area2D = $Sprite2D/Number_b
@onready var bg_sprite_2d: Sprite2D = $Sprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	pass

func __init(num : NumberBlock, _pos : Vector2) -> void:
	if num:
		self.number_a = num
		self.is_level_condition = true
		number_a.global_position = self.target_number_a.global_position
		number_a.z_index = self.z_index + 1
		number_a.is_dragable = false
		GAMEMANAGER.NumberBlockContainer.add_child(num)
	self.position = _pos
	update_bgcolor()

func _physics_process(delta: float) -> void:
	if number_a:
		number_a.global_position = target_number_a.global_position
	if number_b:
		number_b.global_position = target_number_b.global_position

func _process(delta: float) -> void:
	if Input.is_action_pressed("MOUSE_BUTTON_LEFT"):
		if GAMEMANAGER.current_dragging == self:
			global_position = lerp(global_position, get_global_mouse_position(), 20 * delta)
			self.scale = lerp(self.scale, GAMEMANAGER.MAX_PRESS_SCALE, 0.5)
			#using Tween may be fitable to input.position 
			if number_a:
				number_a.scale = lerp(number_a.scale, GAMEMANAGER.MAX_PRESS_SCALE, 0.5)
			if number_b:
				number_b.scale = lerp(number_b.scale, GAMEMANAGER.MAX_PRESS_SCALE, 0.5)
		if GAMEMANAGER.current_dragging == number_a:
			number_a = null
			update_result()
		if GAMEMANAGER.current_dragging == number_b:
			number_b = null
			update_result() #**更新Block的值文本函数**

	else:
		self.scale = lerp(self.scale, GAMEMANAGER.MIN_PRESS_SCALE, 0.5)
		if number_a:
			number_a.scale = lerp(number_a.scale, GAMEMANAGER.MIN_PRESS_SCALE, 0.5)
		if number_b:
			number_b.scale = lerp(number_b.scale, GAMEMANAGER.MIN_PRESS_SCALE, 0.5)
		if target_number_a.has_overlapping_areas() and temp_number_a != null and target_number_a.global_position.distance_to(temp_number_a.global_position) < (target_number_a.get_child(0).shape.size.x * 0.7):
			var tween = create_tween()
			tween.set_trans(Tween.TRANS_BACK)
			tween.set_ease(Tween.EASE_OUT)
			tween.tween_property(temp_number_a, "global_position", target_number_a.global_position, 0.1)
			number_a = temp_number_a # **这行就是之前说的 用于存储吸附动画结束前的吸附物**
			update_result()
			
		if target_number_b.has_overlapping_areas() and temp_number_b != null and target_number_b.global_position.distance_to(temp_number_b.global_position) < (target_number_b.get_child(0).shape.size.x * 0.7):
			var tween = create_tween()
			tween.set_trans(Tween.TRANS_BACK)
			tween.set_ease(Tween.EASE_OUT)
			tween.tween_property(temp_number_b, "global_position", target_number_b.global_position, 0.1)
			number_b = temp_number_b # **这行就是之前说的 用于存储吸附动画结束前的吸附物**
			update_result()
			
func update_result():
	if !number_a or !number_b:
		value = false
	else:
		var number_a_value = number_a.get_value()
		var number_b_value = number_b.get_value()
		if number_a_value == number_b_value:
			value = true
			if is_level_condition:
				MAPINSTANTIATE.load_level(GAMEMANAGER.level_id + 1)
				print("Congratulation!")
				
		else: value = false
	update_bgcolor()
		

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			if event.pressed and GAMEMANAGER.current_dragging == null and !is_mouse_in_area(target_number_a) and !is_mouse_in_area(target_number_b):
				GAMEMANAGER.block_in_mouse_area.append(self)
			else:
				is_dragging = false

func get_value() -> bool:
	return value

func is_mouse_in_area(area : Area2D) -> bool:
	var _shape = area.get_node("CollisionShape2D").shape as RectangleShape2D
	var local_mouse = area.to_local(get_global_mouse_position())
	return Rect2(-_shape.size / 2.0, _shape.size).has_point(local_mouse)

func update_bgcolor():
	if get_value():
		var mat = bg_sprite_2d.material as ShaderMaterial
		mat.set_shader_parameter("bg_color", Vector4(0.960, 0.717, 0.190, 1.0))
	else:
		var mat = bg_sprite_2d.material as ShaderMaterial
		mat.set_shader_parameter("bg_color", Vector4(0.886, 0.196, 0.298, 1.0))

func _on_number_a_area_entered(area: Area2D) -> void:
	if area.is_in_group("NumberArea") and number_a == null and area.is_dragging:
		temp_number_a = area

func _on_number_a_area_exited(area: Area2D) -> void:
	if area == number_a:
		number_a = null

func _on_number_b_area_entered(area: Area2D) -> void:
	if area.is_in_group("NumberArea") and number_b == null and area.is_dragging:
		temp_number_b = area

func _on_number_b_area_exited(area: Area2D) -> void:
	if area == number_b:
		number_b = null
