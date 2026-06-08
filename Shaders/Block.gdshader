shader_type canvas_item;
uniform float border = 0.05;
uniform 	vec4 bg_color : source_color;
uniform vec4 border_color : source_color = vec4(0., 0., 0., 1.);


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	
	if (UV.x < border || UV.x > 1.0 - border || UV.y < border || UV.y > 1.0 - border){
		COLOR = border_color;
	}
	else{
		COLOR = bg_color;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
