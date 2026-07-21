shader_type canvas_item;

uniform vec4 bg_color : source_color;

uniform vec4 curve_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform vec4 point_color : source_color = vec4(0.0, 1.0, 0.0, 1.0);

uniform float a : hint_range(-10, 10) = 1.0;
uniform float b : hint_range(-10, 10) = 0.0;

uniform float line_width : hint_range(0.001, 0.05) = 0.01;

uniform float point_x : hint_range(-10, 10) = 0.0;
uniform float point_size : hint_range(0.01, 0.2) = 0.05;


void fragment() {

	vec2 pixel_size = TEXTURE_PIXEL_SIZE;

	COLOR = bg_color;


	// ===============================
	// 坐标范围
	// ===============================

	float x_range = 5.0;
	float half_x = x_range / 2.0;


	// 计算函数两端高度
	float y_left = a * (-half_x) + b;
	float y_right = a * half_x + b;


	float y_min = min(y_left, y_right);
	float y_max = max(y_left, y_right);


	// 防止水平线缩放异常
	if(abs(a) < 0.001){
		y_min = b - 1.0;
		y_max = b + 1.0;
	}


	// 增加边距
	float margin = max(abs(y_max - y_min) * 0.2, 1.0);

	y_min -= margin;
	y_max += margin;



	// ===============================
	// 固定坐标中心
	// 关键修改
	// ===============================

	float y_center = 0.0;


	// 缩放
	float scale = max(
		half_x,
		max(abs(y_min), abs(y_max))
	);



	// ===============================
	// UV 转数学坐标
	// ===============================

	float x = UV.x * 2.0 * scale - scale;

	float y = 
		(1.0 - UV.y) * 2.0 * scale
		- scale
		+ y_center;



	// ===============================
	// 绘制直线
	// ===============================

	float equation_y = a * x + b;

	float distance_to_line = abs(y - equation_y);


	float threshold = line_width + pixel_size.y;


	if(distance_to_line < threshold){
		COLOR = curve_color;
	}



	// ===============================
	// 绘制点
	// ===============================

	float point_y = a * point_x + b;


	float point_uv_x =
		(point_x + scale)
		/
		(2.0 * scale);



	float point_uv_y =
		1.0 -
		(point_y - y_center + scale)
		/
		(2.0 * scale);



	if(
		point_uv_x >= 0.0 &&
		point_uv_x <= 1.0 &&
		point_uv_y >= 0.0 &&
		point_uv_y <= 1.0
	){

		float dist =
			distance(
				UV,
				vec2(point_uv_x, point_uv_y)
			);


		float size =
			point_size / scale;


		if(dist < size){

			float alpha =
				1.0 -
				smoothstep(
					0.0,
					size,
					dist
				);


			COLOR =
				mix(
					COLOR,
					point_color,
					alpha
				);
		}
	}
}