shader_type canvas_item;
render_mode unshaded, blend_mix;
uniform vec4 albedo : hint_color;
uniform sampler2D texture_albedo : hint_albedo;
uniform vec2 uv_scale = vec2(1.0, 1.0);
uniform vec2 uv_offset;

uniform sampler2D texture_normal : hint_normal;
uniform float normal_scale : hint_range(-16,16);
uniform float flow_normal_influence : hint_range(0, 1);

// Flow / Water uniforms
uniform sampler2D texture_flow_map : hint_normal;
uniform vec4 flow_map_x_channel = vec4(1.0, 0.0, 0.0, 0.0);
uniform vec4 flow_map_y_channel = vec4(0.0, 1.0, 0.0, 0.0);
uniform vec2 channel_flow_direction = vec2(1.0, -1.0);
uniform float blend_cycle = 1.0;
uniform float cycle_speed = 1.0;
uniform float flow_speed =  0.5;

uniform sampler2D texture_flow_noise;
uniform vec4 noise_texture_channel = vec4(1.0, 0.0, 0.0, 0.0);
uniform vec2 flow_noise_size = vec2(1.0, 1.0);
uniform float flow_noise_influence = 0.5;


varying vec2 base_uv;

void vertex() {
	base_uv = UV * uv_scale.xy + uv_offset.xy;
}

void fragment() {
	// UV flow  calculation
	/****************************************************************************************************/
	float half_cycle = blend_cycle * 0.5;

	// Use noise texture for offset to reduce pulsing effect
	float offset = dot(texture(texture_flow_noise, UV * flow_noise_size), noise_texture_channel) * flow_noise_influence;

	float phase1 = mod(offset + TIME * cycle_speed, blend_cycle);
	float phase2 = mod(offset + TIME * cycle_speed + half_cycle, blend_cycle);

	vec4 flow_tex = texture(texture_flow_map, UV);
	vec2 flow;
	flow.x = dot(flow_tex, flow_map_x_channel) * 2.0 - 1.0;
	flow.y = dot(flow_tex, flow_map_y_channel) * 2.0 - 1.0;
	flow *= normalize(channel_flow_direction);

	// Make flow incluence on the normalmap strenght adjustable (optional)
	float normal_influence = mix(1.0, dot(abs(flow), vec2(1.0, 1.0)) * 0.5, flow_normal_influence);

	// Blend factor to mix the two layers
	float blend_factor = abs(half_cycle - phase1)/half_cycle;

	// Offset by halfCycle to improve the animation for color (for normalmap not absolutely necessary)
	phase1 -= half_cycle;
	phase2 -= half_cycle;

	// Multiply with scale to make flow speed independent from the uv scaling
	flow *= flow_speed * uv_scale;

	vec2 layer1 = flow * phase1 + base_uv;
	vec2 layer2 = flow * phase2 + base_uv;
	/****************************************************************************************************/

	// Albedo
	// Mix animated uv layers
	vec4 albedo_tex = mix(texture(texture_albedo, layer1), texture(texture_albedo, layer2), blend_factor);
	COLOR.rgb = albedo.rgb * albedo_tex.rgb;
	
	// Normalmap
	// Mix animated uv layers
	NORMALMAP = mix(texture(texture_normal, layer1), texture(texture_normal, layer2), blend_factor).rgb;
	NORMALMAP_DEPTH = normal_scale * normal_influence;
}
