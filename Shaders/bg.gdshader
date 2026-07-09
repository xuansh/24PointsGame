shader_type canvas_item;

uniform vec4 bg_color : source_color = vec4(0.34,0.34,0.34,1.0);
uniform vec4 grid_color : source_color = vec4(1.0,1.0,1.0,0.035);
uniform float grid_size = 48.0;
uniform float line_width = 1.0;

void fragment()
{
    vec2 p = FRAGCOORD.xy;

    float gx = step(mod(p.x, grid_size), line_width);
    float gy = step(mod(p.y, grid_size), line_width);

    float g = max(gx, gy);

    COLOR = mix(bg_color, grid_color, g);
}