shader_type canvas_item;

uniform float outer_width = 12.0;
uniform float inner_width = 4.0;

uniform vec4 outer_color : source_color = vec4(0.35, 0.25, 0.15, 1.0);
uniform vec4 inner_color : source_color = vec4(0.95, 0.85, 0.55, 1.0);

void fragment()
{
	vec2 px_outer = SCREEN_PIXEL_SIZE * outer_width;
	vec2 px_inner = SCREEN_PIXEL_SIZE * (outer_width - inner_width);

	bool in_outer =
		SCREEN_UV.x < px_outer.x ||
		SCREEN_UV.y < px_outer.y ||
		SCREEN_UV.x > 1.0 - px_outer.x ||
		SCREEN_UV.y > 1.0 - px_outer.y;

	bool in_inner =
		SCREEN_UV.x < px_inner.x ||
		SCREEN_UV.y < px_inner.y ||
		SCREEN_UV.x > 1.0 - px_inner.x ||
		SCREEN_UV.y > 1.0 - px_inner.y;

	if (in_outer)
	{
		if (in_inner)
			COLOR = inner_color;
		else
			COLOR = outer_color;
	}
	else
	{
		discard;
	}
}