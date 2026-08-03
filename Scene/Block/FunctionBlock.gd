extends Block

class_name FunctionBlock

@onready var target_a : Area2D = $X_sprite/A
@onready var target_x : Area2D = $X_sprite/X
@onready var target_b : Area2D = $X_sprite/B
@onready var label: Label = $Label
@onready var y_sprite: Sprite2D = $Y_sprite
@onready var texture_button: TextureButton = $TextureButton
@onready var output_marker_2d: Marker2D = $Output_sprite/Marker2D
@onready var press_here: Label = $Press_here

@export var value : float

var Y_mat : ShaderMaterial = null
var a : NumberBlock = null
var x : NumberBlock = null
var b : NumberBlock = null
var temp_a : NumberBlock = null
var temp_x : NumberBlock = null
var temp_b : NumberBlock = null
var texture_btn_tween : Tween
var number_block_move_tween : Tween


func __init(num_a : NumberBlock, num_b : NumberBlock, _pos : Vector2):
	Y_mat = y_sprite.material as ShaderMaterial
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
		setter_function_a(a.get_value())
		setter_function_b(b.get_value())
		update_label()


func _process(delta: float) -> void:
	if Input.is_action_pressed("MOUSE_BUTTON_LEFT"):
		if GAMEMANAGER.current_dragging == self:
			global_position = lerp(global_position, get_global_mouse_position(), 20 * delta)
			self.scale = lerp(self.scale, GAMEMANAGER.MAX_PRESS_SCALE, 0.5)
			# 统一处理所有子方块
			var children = [a, x, b]
			var targets = [target_a, target_x, target_b]
			for i in range(3):
				var child = children[i]
				var target = targets[i]
				if child:
					child.global_position = target.global_position
					child.scale = lerp(child.scale, GAMEMANAGER.MAX_PRESS_SCALE, 0.5)
		if GAMEMANAGER.current_dragging == a:
			a = null
			update_label()
		if GAMEMANAGER.current_dragging == x:
			x = null
			update_label()
		if GAMEMANAGER.current_dragging == b:
			b = null
			update_label()
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
			update_label()

		if target_b.has_overlapping_areas() and temp_b != null and target_b.global_position.distance_to(temp_b.global_position) < (target_b.get_child(0).shape.size.x * 0.7):
			var tween = create_tween()
			tween.set_trans(Tween.TRANS_BACK)
			tween.set_ease(Tween.EASE_OUT)
			tween.tween_property(temp_b, "global_position", target_b.global_position, 0.1)
			b = temp_b
			update_label()

		if target_x.has_overlapping_areas() and temp_x != null and target_x.global_position.distance_to(temp_x.global_position) < (target_x.get_child(0).shape.size.x * 0.7):
			var tween = create_tween()
			tween.set_trans(Tween.TRANS_BACK)
			tween.set_ease(Tween.EASE_OUT)
			tween.tween_property(temp_x, "global_position", target_x.global_position, 0.1)
			x = temp_x
			update_label()

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT and !is_mouse_in_area(target_a) and !is_mouse_in_area(target_x) and !is_mouse_in_area(target_b):
			if event.pressed and GAMEMANAGER.current_dragging == null:
				GAMEMANAGER.block_in_mouse_area.append(self)
			else:
				if is_dragging:
					is_dragging = false

func update_label() -> void:
	if x and a:
		value = a.get_value() * x.get_value() + (b.get_value() if b else 0)
	elif b:
		value = b.get_value()
	label.text = str(value)

func able_to_output_value() -> bool:
	if x and value:
		return true
	return false

func _queue_free_x() -> void:
	if x:
		x.queue_free()
		x = null
	update_label()
#region signal

func _on_a_area_entered(area: Area2D) -> void:
	if area.is_in_group("NumberArea") and a == null and area.is_dragging:
		temp_a = area

func _on_x_area_entered(area: Area2D) -> void:
	if area.is_in_group("NumberArea") and x == null and area.is_dragging:
		temp_x = area

func _on_b_area_entered(area: Area2D) -> void:
	if area.is_in_group("NumberArea") and b == null and area.is_dragging:
		temp_b = area

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				_on_texture_button_button_down()

#endregion

#region setter

func setter_function_a(a : float):
	Y_mat.set_shader_parameter("a", a)

func setter_function_b(b : float):
	Y_mat.set_shader_parameter("b", b)

#endregion

#region getter

func get_value() -> float:
	return value

#endregion

func _on_texture_button_button_down() -> void:
	GAMEMANAGER.print_all_block_position()
	
	if texture_btn_tween and texture_btn_tween.is_running():
		return
	texture_btn_tween = get_tree().create_tween().set_parallel(true)
	var target_offset_x : float = 10.0
	var origin_x = texture_button.position.x
	var tween_time : float = 0.2
	texture_btn_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

	var NB : NumberBlock # 保存生成的NumberBlock, 用于做tween动画
	var nb_target_offset_y : float = -80.0
	var nb_tween_time = 0.4

	#生成NumberBlock
	if able_to_output_value() and !is_nan(get_value()):
		NB = GAMEMANAGER.spawn_a_NumberBlock(get_value(), "Number", output_marker_2d.global_position)
		_queue_free_x()

		number_block_move_tween = get_tree().create_tween().set_parallel(true)
		number_block_move_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)

		# 生成NumberBlock后, 指引消失(说明玩家已了解Block的用法)

		if press_here != null:
			press_here.queue_free()
			
		number_block_move_tween.tween_property(NB, "global_position:y", NB.global_position.y + nb_target_offset_y, nb_tween_time)
		

	#NOTICE GO
	texture_btn_tween.tween_property(texture_button, "position:x", texture_button.position.x + target_offset_x, tween_time)

	#NOTICE BACK
	texture_btn_tween.chain().tween_property(texture_button, "position:x", origin_x, tween_time)
