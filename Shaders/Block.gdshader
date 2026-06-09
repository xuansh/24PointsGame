shader_type canvas_item;
uniform float border_pixels = 5.0;  // 使用像素单位
uniform vec4 bg_color : source_color;
uniform vec4 border_color : source_color = vec4(0., 0., 0., 1.);

void fragment() {
	// 获取每个像素在UV空间中的大小
	vec2 pixel_size = TEXTURE_PIXEL_SIZE;
	
	// 将border从像素转换为UV空间
	float border_uv_x = border_pixels * pixel_size.x;
	float border_uv_y = border_pixels * pixel_size.y;
	
	if (UV.x < border_uv_x || UV.x > 1.0 - border_uv_x || 
	    UV.y < border_uv_y || UV.y > 1.0 - border_uv_y){
		COLOR = border_color;
	}
	else{
		COLOR = bg_color;
	}
}