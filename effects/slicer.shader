shader_type canvas_item;
uniform sampler2D texture;
uniform vec2 origin = vec2(0.5, 0.5);
uniform float gradient;
uniform bool invert;

void fragment() {
    vec4 texture_v = texture(texture, UV);
	
	if ((UV.y < gradient * (UV.x - origin.x) + origin.y) == invert) {
		texture_v.a = 0.
	}
	
	COLOR = texture_v;
}